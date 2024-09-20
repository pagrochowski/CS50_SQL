# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning

Random partitioning would in theory distribute the data load evenly between boats, which is good for writing the data. However, reading the data is going to take longer and will be more resource hungry process, if we need to query all boats each time we want to make a single query. 

## Partitioning by Hour

This approach is the opposite of random partitioning. Reading data will be easier, as we will know for sure, which boat to query about which piece of data we want to retrieve (given that we know the timing). On the other hand,data will not be evenly distributed between boats, so we run the risk of overloading the capacity on one of them and underutilise on the others.

## Partitioning by Hash Value

Seemingly most reasonable approach, it evenly distributes the data between boats. We know where to run the query, given the data timing is known. The only trade off I can think of would be the fact that we do have to run a separate process of hashing the timestamps, which will take time and resources away. But this sounds like a marginal downside, given other upsides. 
