#first simple NN based on Keras 

library(keras)
# Turn `iris` into a matrix
newiris <- iris
newiris[,5] <- as.numeric(newiris[,5]) -1
newiris <- as.matrix(newiris)



# Set iris `dimnames` to `NULL`
dimnames(newiris) <- NULL
# Normalize the `iris` data (not necessary)
#newiris <- matrix(c(normalize(newiris[,1:4]),newiris[,5]), ncol = 5)

# Return the summary of `iris`
summary(newiris)


# Determine sample size
ind <- sample(2, nrow(newiris), replace=TRUE, prob=c(0.67, 0.33))

# Split the `iris` data
iris.training <- newiris[ind==1, 1:4]
iris.test <- newiris[ind==2, 1:4]

# Split the class attribute
iris.trainingtarget <- newiris[ind==1, 5]
iris.testtarget <- newiris[ind==2, 5]

# One hot encode training target values
iris.trainLabels <- to_categorical(iris.trainingtarget)

# One hot encode test target values
iris.testLabels <- to_categorical(iris.testtarget)

# Print out the iris.testLabels to double check the result
print(iris.testLabels)

# Initialize a sequential model
model <- keras_model_sequential() 

# Add layers to the model v1
model %>% 
  layer_dense(units = 8, activation = 'relu', input_shape = c(4)) %>% 
  layer_dense(units = 3, activation = 'softmax')

#model v2
# Add layers to model
model %>% 
  layer_dense(units = 8, activation = 'relu', input_shape = c(4)) %>% 
  layer_dense(units = 5, activation = 'relu') %>% 
  layer_dense(units = 3, activation = 'softmax')

#model v3
# Add layers and hidden units to model
model %>% 
  layer_dense(units = 20, activation = 'relu', input_shape = c(4)) %>%
  layer_dense(units = 5, activation = 'relu') %>% 
  layer_dense(units = 3, activation = 'softmax')


#check structure of model
summary(model)
# Get model configuration
get_config(model)
# Get layer configuration
get_layer(model, index = 1)
# List the model's layers
model$layers
# List the input tensors
model$inputs
# List the output tensors
model$outputs


# Compile the model with adam
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = 'adam',
  metrics = 'accuracy'
)
# Compile the model with sgd
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_sgd(lr=.01),
  metrics = 'accuracy'
)

# Fit the model
model %>% fit(
  iris.training, 
  iris.trainLabels, 
  epochs = 200, 
  batch_size = 10, 
  validation_split = 0.2
)

# Predict the classes for the test data
classes <- model %>% predict_classes(iris.test, batch_size = 128)
# Confusion matrix
table(iris.testtarget, classes)

# Evaluate on test data and labels
score <- model %>% evaluate(iris.test, iris.testLabels, batch_size = 128)
# Print the score
print(score)

