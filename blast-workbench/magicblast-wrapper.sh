#!/bin/bash
# magicblast-wrapper.sh: Simple wrapper script for MagicBLAST to properly set
# LD_LIBRARY_PATH
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Sat Nov  3 09:55:03 2018

export LD_LIBRARY_PATH="/magicblast/lib:${LD_LIBRARY_PATH}"
magicblast.REAL $*

