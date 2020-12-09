######
#Please define the type of embeddings you want to use here:
local bert_model = "bert-base-multilingual-cased";
#Please define the dataset_reader you want to use here:
local datasetreader = "textannotation_ner";

{
  "dataset_reader": {
    "type": datasetreader,
    "tag_label": "ner",
    "coding_scheme": "BIOUL",
    "sentence_length_threshold": 300,
    "token_indexers": {
      "bert": {
          "type": "bert-pretrained",
          "pretrained_model": bert_model,
          "do_lowercase": false,
          "use_starting_offsets": true
      },
      "token_characters": {
        "type": "characters",
        "min_padding_length": 3
      }
    }
  },
  "train_data_path": std.extVar("NER_TRAIN_DATA_PATH"),
  "validation_data_path": std.extVar("NER_TEST_A_PATH"),
  "test_data_path": std.extVar("NER_TEST_B_PATH"),
  "evaluate_on_test": true,   
  "model": {
    "type": "crf_tagger",
    "label_encoding": "BIOUL",
    "constrain_crf_decoding": true,
    "calculate_span_f1": true,
    "dropout": 0.5,
    "include_start_end_transitions": false,
    "text_field_embedder": {
        "allow_unmatched_keys": true,
        "embedder_to_indexer_map": {
            "bert": ["bert", "bert-offsets"],
            "token_characters": ["token_characters"],
        },
        "token_embedders": {
            "bert": {
                "type": "bert-pretrained",
                "pretrained_model": bert_model,
            },
            "token_characters": {
                "type": "character_encoding",
                "embedding": {
                    "embedding_dim": 16
                },
                "encoder": {
                    "type": "cnn",
                    "embedding_dim": 16,
                    "num_filters": 128,
                    "ngram_filter_sizes": [3],
                    "conv_layer_activation": "relu"
                }
            }
        }
    },
    "encoder": {
        "type": "lstm",
        "input_size": 768 + 128,
        "hidden_size": 200,
        "num_layers": 2,
        "dropout": 0.5,
        "bidirectional": true
    },
  },
  "iterator": {
    "type": "basic",
    "batch_size": 16
  },
  "trainer": {
    "optimizer": {
        "type": "adam",
        "lr": 0.001
    },
    "validation_metric": "+f1-measure-overall",
    "num_serialized_models_to_keep": 1,
    "num_epochs": 75,
    "grad_norm": 5.0,
    "patience": 25,
    "cuda_device": 0
  }
}
