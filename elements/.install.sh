#!/bin/bash

echo "Install CSS..." && \
    mkdir -p static/ && \
    cp elements/style.css static/ && \
    cp elements/ocsigen_logo.png static/ && \
    echo "Done"
