#!/bin/bash

mongoimport --db web-app --collection web-app-collection --file data.json --jsonArray
exit 0
