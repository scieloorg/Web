<?php

/**
 * Runs WXIS without invoking a shell and enforces a hard execution deadline.
 *
 * Keeping the command as an argument array avoids shell interpretation. The
 * caller receives stdout even when WXIS exits unsuccessfully so the legacy
 * error handling can continue to inspect its response.
 */
function scielo_run_process_with_timeout($command, $timeoutSeconds)
{
    if (!is_array($command) || count($command) === 0) {
        throw new InvalidArgumentException('A non-empty command array is required');
    }

    $timeoutSeconds = (float) $timeoutSeconds;
    if ($timeoutSeconds <= 0) {
        throw new InvalidArgumentException('The process timeout must be positive');
    }

    $descriptors = array(
        1 => array('pipe', 'w'),
        2 => array('pipe', 'w'),
    );
    $pipes = array();
    $process = proc_open(
        array_values($command),
        $descriptors,
        $pipes,
        null,
        null,
        array('bypass_shell' => true)
    );

    if (!is_resource($process)) {
        throw new RuntimeException('Unable to start WXIS');
    }

    stream_set_blocking($pipes[1], false);
    stream_set_blocking($pipes[2], false);

    $startedAt = microtime(true);
    $deadline = $startedAt + $timeoutSeconds;
    $stdout = '';
    $stderr = '';
    $timedOut = false;
    $lastStatus = null;

    while (true) {
        $stdout .= stream_get_contents($pipes[1]);
        $stderr .= stream_get_contents($pipes[2]);
        $lastStatus = proc_get_status($process);

        if (!$lastStatus['running']) {
            break;
        }

        if (microtime(true) >= $deadline) {
            $timedOut = true;
            proc_terminate($process, 15);

            $graceDeadline = microtime(true) + 0.25;
            do {
                usleep(10000);
                $stdout .= stream_get_contents($pipes[1]);
                $stderr .= stream_get_contents($pipes[2]);
                $lastStatus = proc_get_status($process);
            } while ($lastStatus['running'] && microtime(true) < $graceDeadline);

            if ($lastStatus['running']) {
                proc_terminate($process, 9);
            }
            break;
        }

        usleep(10000);
    }

    $stdout .= stream_get_contents($pipes[1]);
    $stderr .= stream_get_contents($pipes[2]);
    fclose($pipes[1]);
    fclose($pipes[2]);

    $closeExitCode = proc_close($process);
    $exitCode = is_array($lastStatus) && isset($lastStatus['exitcode'])
        && $lastStatus['exitcode'] >= 0
        ? $lastStatus['exitcode']
        : $closeExitCode;

    return array(
        'stdout' => $stdout,
        'stderr' => substr($stderr, 0, 1000),
        'exit_code' => $exitCode,
        'timed_out' => $timedOut,
        'duration_ms' => (int) round((microtime(true) - $startedAt) * 1000),
    );
}

function scielo_wxis_timeout_seconds()
{
    $configured = getenv('SCIELO_WXIS_TIMEOUT_SECONDS');
    if ($configured !== false && preg_match('/^[0-9]+$/D', $configured)) {
        $seconds = (int) $configured;
        if ($seconds >= 1 && $seconds <= 120) {
            return $seconds;
        }
    }

    return 20;
}

function scielo_wxis_script_name($arguments)
{
    foreach ($arguments as $argument) {
        if (strpos($argument, 'IsisScript=') !== 0) {
            continue;
        }

        $script = rawurldecode(substr($argument, strlen('IsisScript=')));
        if (preg_match('#^[A-Za-z0-9_./-]{1,160}$#D', $script)) {
            return $script;
        }
    }

    return 'unknown';
}
