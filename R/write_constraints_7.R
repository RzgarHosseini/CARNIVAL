#'\code{write_constraints_7}
#'
#'@param variables Contains the list of variables as used to formulate the ILP problem, explanations for each variable and a list of useful indices.
#'@param dataMatrix Contains the matrix which stores the data for running CARNIVAL and a set of identifiers for Targets, Measured and Un-measured nodes.
#'@param inputs Contains the list of targets as inputs.
#'
#'@import igraph
#'
#'@return This code writes the list of constraints (7) of the ILP problem for all the conditions.

write_constraints_7 <- function(variables=variables, dataMatrix=dataMatrix, inputs = inputs) {
  
  library(igraph)
  constraints7 <- c()
  
  for(ii in 1:length(variables)){
    
    source <- unique(variables[[ii]]$reactionSource)
    target <- unique(variables[[ii]]$reactionTarget)
    
    gg <- graph_from_data_frame(d = pknList[, c(3, 1)])
    adj <- get.adjacency(gg)
    adj <- as.matrix(adj)
    
    idx1 <- which(rowSums(adj)==0)
    idx2 <- setdiff(1:nrow(adj), idx1)
    
    if (length(idx1)>0) {
      constraints7 <- c(constraints7, paste0(variables[[ii]]$variables[which(variables[[ii]]$exp%in%paste0("SpeciesDown ", rownames(adj)[idx1], " in experiment ", ii))], " <= 0"))
    } 
    
    for(i in 1:length(idx2)){
      
      cc <- paste0(variables[[ii]]$variables[which(variables[[ii]]$exp==paste0("SpeciesDown ", rownames(adj)[idx2[i]], " in experiment ", ii))], 
                   paste(paste0(" - ", variables[[ii]]$variables[which(variables[[ii]]$exp%in%paste0("ReactionDown ", colnames(adj)[which(adj[idx2[i], ]>0)], "=", rownames(adj)[idx2[i]], " in experiment ", ii))]), collapse = ""), " <= 0")
      
      constraints7 <- c(constraints7, cc)
      
    }
    
  }
  
  return(constraints7)
}
