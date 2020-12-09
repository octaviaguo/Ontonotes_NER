#!/usr/bin/env bash

################################
#Please define the following paths
#Model_path=
#Train_path=
#Dev_path=
#Test_path=
###############################

export NER_TRAIN_DATA_PATH=$Train_path
export NER_TEST_A_PATH=$Dev_path
export NER_TEST_B_PATH=$Test_path

SERIALIZATION_DIR=$Model_path
CONFIGFILE=./ner.jsonnet
INCLUDE_PACKAGE=ccg


echo ""
echo "Config file: ${CONFIGFILE}"
echo "Save your model to: ${SERIALIZATION_DIR}"
echo ""

read -p "Continue (Y/N) " continue
if ! ( [ "${continue}" = "y" ] || [ "${continue}" = "Y" ] ); then exit 1; else echo "Continuing ... "; fi

# Simple logic to make sure existing serialization dir is safely deleted
if [ -d "${SERIALIZATION_DIR}" ]; then
    echo "SERIALIZATION_DIR EXISTS: ${SERIALIZATION_DIR}"
    read -p "Delete? Or resume? (Y/N/r) " delete

    if [ "${delete}" = "y" ] || [ "${delete}" = "Y" ]; then
        echo "Deleting ${SERIALIZATION_DIR}"
        rm -r ${SERIALIZATION_DIR}
    elif [ "${delete}" = "r" ] || [ "${delete}" = "R" ]; then
        RECOVER_FLAG="-r"
    else
        echo "Not deleting ${SERIALIZATION_DIR}"
        echo "Cannot continue with non-empty serialization dir. Exiting"
        exit 1
    fi
fi


allennlp train $CONFIGFILE $RECOVER_FLAG -s $SERIALIZATION_DIR --include-package $INCLUDE_PACKAGE 


