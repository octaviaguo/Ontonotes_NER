# Ontonotes_NER
Train an NER model on Ontonotes V5.

## Instructions
1. Please define the data paths and model path in run.sh;
2. If you want to use your self-designed dataset_reader, please move your dataset_reader code to "./ccg/dataset_readers/", and include the name of dataset_reader file into "./ccg/\__init\__.py". 
3. Please define the pretrained embeddings (eg. multilingual BERT) and the name of your dataset_reader in ner.jsonnet;
4. Run the following command:
```
sh run.sh
```
