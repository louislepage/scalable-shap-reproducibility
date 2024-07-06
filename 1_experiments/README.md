# Experiments

## Runtime
All experiments were run using some simple bash scripts to run with different parameters. 
We used the `shapley-permutation-experiment.dml` script to run all versions of our method and the 
`./shap-permutation.py` script to runt he version from the python shap package. 
A rough example is given in `./test_runtimes_permutation.sh`.

### Our Versions in SystemDS
After preparation, each SystemDS version can be run using the following command:
```
systemds ./shapley-permutation-experiment.dml -stats 1 -nvargs \
    data_dir=<data-dir> \
    X_bg_path=<backgrond-data.csv> \
    B_path=<model-weight-and-biases.csv> \
    metadata_path=<prepared-partitions.csv> \
    n_permutations=<n-permutations> \
    integration_samples=<n-samples> \
    rows_to_explain=<n-instances> \
    write_to_file=0 \
    model_type=<model-from-below> \
    execution_policy=<one-of-below>
```

Available dataset/model combinations are:
- Logistic Regression on Adult: `data_dir=../data/adult/ X_bg_path=Adult_X.csv B_path=Adult_W.csv metadata_path=Adult_meta.csv model_type=multiLogRegPredict` 
- SVM on Census: `data_dir=../data/census/ X_bg_path=census_xTrain.csv B_path=census_bias.csv metadata_path=census_dummycoding_meta.csv model_type=l2svmPredict`
- FNN on Adult: `data_dir=../data/adult/ X_bg_path=Adult_X.csv B_path=ffn_model.bin metadata_path=Adult_partitions.csv model_type=ffPredict`

`execution_policy` maps to the versions in the thesis as follows:
- `by-row`: Parallel
  - enable removal of non-varing features and partitioning ba setting  `remove_non_var=1` or `use_
    partitions=1` respectively
- `legacy`: Vectorized Preparation
- `legacy-iterative`: Iterative Preparation

> Appending `2>/dev/null | grep "Total elapsed time" | awk '{print $4}' | tr \, \.)` allows to only output the runtime.

### Cluster execution
For cluster execution, the data needs to be available on each executor, e.g. in Hadoop. Change the `data_dir` accordingly.
Additionally, the par-for loop in the explainer needs to be modified as explained in the comment in the code.



### Python Reference
The script `./shap-permutation.py` loads the desired prepared model and runs the explainer from the shap package.
It can be executed using the following command:

```
python ./shap-permutation.py \
    --data-dir=/home/lepage/data/adult/ \
    --data-x=Adult_X.csv \
    --model-type=multiLogReg \
    --n-permutations=${permutations} \
    --n-instances=${instances} \
    --silent \
    --just-print-t
```
This outputs only the runtime to be stored for comparison. Replace `data-dir`, `data-x`, and `model-type` to run for different versions. 

### Store the Results
We stored all runtimes in a csv with the following header:
```exp_type,instances,runtime_python,runtime_row,runtime_row_non_var,runtime_row_partitioned,runtime_permutation,runtime_legacy,runtime_legacy_iterative```

Such a file can be used with the evaluation scripts to creat the plots.

## Accuracy
Compute SHAP values using the final method:
```
systemds ./shapley-permutation-experiment.dml -stats 1 -nvargs \
    data_dir=<data-dir> \
    X_bg_path=<backgrond-data.csv> \
    B_path=<model-weight-and-biases.csv> \
    metadata_path=<prepared-partitions.csv> \
    n_permutations=<n-permutations> \
    integration_samples=<n-samples> \
    rows_to_explain=<n-instances> \
    write_to_file=1 \
    model_type=<model-from-below> \
    execution_policy=final-parallel
```
See runtime for explanations of parameters.

Compute using python:
```
python ./shap-permutation.py \
    --data-dir=/home/lepage/data/adult/ \
    --data-x=Adult_X.csv \
    --model-type=multiLogReg \
    --n-instances=<instances> \
    --n-permutations=<n-permutations> \
    --n-samples=<n-samples>
    --silent \
    --result-file-name="shap-values_permutation.csv" 
```
