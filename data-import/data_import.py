#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Data importer from Zalando API to PostgreSQL
Copyright (c) Artem Panchoyan
License: MIT

Usage:
  data-import import-all [<api_url>] [<connection_string>] [--log-file <log_file_name>]
  data-import -h | --help
  data-import -v | --version

Arguments:
  <connection_string>       Connection string to postgres database.
                            Can be in any format psycopg2 would understand it
  <api_url>                 Zalando API URL

Options:
  -h --help                 Show this screen.
  -v --version              Show version.
  --log-file <log_file_name>
                            Log into a specified file. If not specified, logs are issued to stdout

"""
import json
import logging
import os

import sys
import colorama

import psycopg2
import math
from docopt import docopt
import settings

import requests

# getting logging
from psycopg2._json import Json

logger = logging.getLogger(__name__)


def main():
    arguments = docopt(__doc__, version='0.0.1')
    colorama.init()

    _app_name = 'sky-search'

    # setting logging
    formatter = logging.Formatter(settings.LOGGING_FORMATTER)
    logger_level = logging.DEBUG
    logger.setLevel(logger_level)
    if arguments['--log-file']:
        handler = logging.FileHandler(os.path.abspath(os.path.expanduser(arguments['--log-file'])))
        handler.setLevel(logger_level)
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    else:
        handler = logging.StreamHandler()
        handler.setLevel(logger_level)
        handler.setFormatter(formatter)
        logger.addHandler(handler)

    print('Initialising')
    if arguments['<api_url>']:
        api_url = arguments['<api_url>']
    else:
        api_url = 'https://api.zalando.com/articles'
    if arguments['<connection_string>']:
        connection_string = arguments['<connection_string>']
    else:
        connection_string = 'postgresql://postgres:postgres@localhost:5432/postgres'
    if arguments['import-all']:
        logger.info('Connecting to DB... {0}'.format(connection_string))
        conn = psycopg2.connect(arguments['<connection_string>'])
        logger.info('Connected to DB... {0}'.format(connection_string))
        logger.info('Fetching api metadata from {0}'.format(api_url))
        r = requests.get('{0}?{1}&{2}'.format(api_url, 'page=1', 'pageSize=1'))
        if r.status_code == 200:
            r_json = r.json()
            r_size = sizeof_fmt(len(r.content)*r_json['totalElements'])
            print('Fetching {0} articles. Total size about {1}.'.format(r_json['totalElements'], r_size))
            logger.info('Started fetching. Fetching {0} articles. Total size about {1}'.format(r_json['totalElements'],
                                                                                          r_size))
            n_pages = int(math.ceil(r_json['totalElements']/200))
            # n_pages = 2 # for testing, comment in production
            cur = conn.cursor()
            for page in range(1, n_pages):
                req_page = requests.get('{0}?{1}&{2}'.format(api_url, 'page={0}'.format(page), 'pageSize=200'))
                req_p_json = req_page.json()
                print('Fetched page {0} out of {1}. Each page has 200 articles.'
                      .format(page, n_pages))
                logger.info(
                    'Fetched page {0} out of {1}. Each page has 200 articles.'
                        .format(page, n_pages))
                exec_str = "INSERT INTO sky_search_data.input_json (ij_json) VALUES "
                for content in req_p_json['content'][:-1]:
                    exec_str += cur.mogrify("(%s),",[Json(content)])
                exec_str += cur.mogrify("(%s);", [Json(req_p_json['content'][-1])])
                cur.execute(exec_str)
            conn.commit()
            cur.close()
        else:
            print('Oops, something went wrong. Check the logs.')
            logger.exception('Request to Zalando API failed with status code {0}'.format(r.status_code))
        conn.close()


def sizeof_fmt(num, suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)


if __name__ == '__main__':
    main()
