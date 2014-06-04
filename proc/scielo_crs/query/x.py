def main():
    import argparse
    import sys

    parser = argparse.ArgumentParser(description='CrossRef Query utility')
    parser.add_argument('--articles', help='query doi for articles', action='store_false')
    parser.add_argument('--references', help='query doi for references', action='store_true')
    parser.add_argument('--pending', help='query doi for pending items', action='store_false')
    parser.add_argument('--new', help='query doi for new/updated items', action='store_true')
    parser.add_argument('update_from', help='update query data from a given date (YYYYMMDD)')

    args = parser.parse_args()
    if args.update_from:
        print('update from')
    print(args)    

if __name__ == '__main__':
    main()
