#!/bin/bash
cd terraform && \
    rm -rf .terraform/ && \
    rm .terraform.lock.hcl && \
    rm terraform.tfstate && \
    rm terraform.tfstate.backup