# Prediction-of-electrical-demand-using-kernel-methods
Prediction of electrical demand using kernel methods

The objective of this work is to implement a forecasting methodology for next week's energy consumption. From an engineering point of view, anyone responsible for an electrical service network needs to be able to make an accurate forecast as this is something that affects many other system components such as transmission and distribution, on the other hand, electric charge is a determining factor in the price of energy as it is an indicator of demand , so it should also be a reliable model. Accurate and reliable models are also critical in risk assessment and management.


First of all, the transformation of the data was carried out since they are segmented with the hourly demand and for the realization of this work we will take into account only the daily electricity consumption. To do this we have accumulated each day by adding the consumptions of the corresponding 24 hours using the dem_diaria.m. function.

Due to the high consumption values that lead to delays in calculations and processing, it was chosen to scale the data, that is, normalize it from 0 to 1, using the normalize.m function and to return the denormalize.m function to the original scaling.

For the formation of the vectors of the regressors, an a regressor.m function was developed which, from the day entered, the historical dataset, the type of regressor to conform and its dimension, returns the corresponding vector. 

In this work we will first select a range of each parameter and compare the results they yield, which is a reliable, objective and feasible procedure to obtain the optimal value with the least prediction error; and for this we have created the Busq_malla.m function that uses the Mesh Search technique, which due to its simplicity is widely used by many researchers in the area of machine learning. This procedure involves constructing a dimensioned mesh of parameter vectors containing all possible combinations in a search space and for a chosen discretization step. Because it is necessary to use some measure of method performance, cross-validation of n partitions is used so that the chosen parameter vector is the one for which the validation error is less for a specific task. 

For the calculation of prediction using kernel methods, the compute_kernel_prediction.m function whose input parameters are the type of kernel function to use, the regressor, the training set, and hyperparameters has also been developed. As is widely known, one of the most important factors in performance is the selection of the kernel function, however, in practice very few are used due to the inherent difficulty in adjusting such parameters. 

So, we will only work with linear, radial base and polynomial functions; and for your choice we have developed the following script with the Opt_kernel.m function that returns the average error of using each kernel function using cross-validation with a split of the data into 10 subsets.
