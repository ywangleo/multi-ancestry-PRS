library(MASS)
library(data.table)
args <- commandArgs(trailingOnly = T)
irep <- args[1]

Rep <- paste0("Rep", irep)
setwd("/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations")

##parameters used
#Ms <- c(100, 500, 1000) ##number of causal variants
Ms <- c(100)
pops <- c("EUR", "AFR", "EAS") ##populations simulated
K <- length(pops)
#h2s   <- c(0.01, 0.03, 0.05) ##h2 in population1
#h2s <- c(0.1, 0.3, 0.5)
h2s   <- c(0.01)
Ss1 <- c(-1, -1, -1) ## Selection power
Ss2 <- c(-1, -1, -1)
Ss <- rbind(Ss1, Ss2)
rb   <-   1 # correlation of effect sizes
Rbm  <- matrix(rb,K,K); diag(Rbm) <- 1

set.seed(1234)

all <- fread("/humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_pops_frq.txt", header = T, stringsAsFactors = F)

#for(s in 1:nrow(Ss)){
  for(s in 2:nrow(Ss)){
    for(m in 1:length(Ms)){
        S <- Ss[s,][1]
	    ##sample causal variants
	        M <- Ms[m]
		    dat <- all
		        dat1 <- dat[sample(nrow(dat), M),]
			    caus <- dat1$ID
			        write.table(caus, paste0("snplist/caus", M, "-rep", irep, "-S1_", S, ".snplist"), col.names = F, row.names = F, quote = F, sep = "\t")
				    
				        # heterozygosity at causal variants
					    all1 <- all[match(caus, ID),]
					        h <- as.matrix(all1[,11:13])
						    colnames(h) <- pops
						        rownames(h) <- caus
							    
							        ## simulated betas
								    b_scaled  <- do.call("rbind",lapply(1:M,function(j) mvrnorm(1,mu=rep(0,K),Sigma=tcrossprod( sqrt(h[j,]**Ss[s,]) ) * Rbm )))
								        gs <- list()
									    vgs <- vector()
									        
										    for(p in 1:length(pops)){
										          pop <- pops[p]
											        score <- data.frame(caus, all1$EUR_ALT, b_scaled[,p])
												      fwrite(score, paste0("scores/caus", M, "-my-score_P", irep, "-S1_", S, "-", pop, ".txt"), col.names = F, row.names = F, quote = F, sep = "\t")
												            system(paste0("~/plink2 --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_", pop, "_qcd --remove /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_", pop, "_rel.idlist --score scores/caus", M, "-my-score_P", irep, "-S1_", S, "-", pop, ".txt 1 2 3 cols=+scoresums center --threads 4 --out profiles/caus", M, "-rep", irep, "-S1_", S, "-", pop))
													          prs <- fread(paste0("profiles/caus", M, "-rep", irep, "-S1_", S, "-", pop, ".sscore"), header = T, stringsAsFactors = F)
														        gs[[p]] <- prs
															      vg_scaled <- var(prs$SCORE1_SUM)
															            vgs[p] <- vg_scaled
																        }
																	    
																	        for(l in 1:length(h2s)){
																		      h2 <- h2_2 <- h2s[l]
																		            vg1 <- vgs[1]
																			          #h2_pops <- vector()
																				        for(pp in 1:length(pops)){
																					        pop1 <- pops[pp]
																						        vg2 <- vgs[pp]
																							         
																								         # h2_pops[pp] <- h2_2
																									         varb <- h2_2/vg2
																										         N <- nrow(gs[[pp]])
																											         e_pop <- rnorm(N, mean=0, sd =  sqrt((1 - h2_2)))
																												         g_pop <- gs[[pp]]$SCORE1_SUM * sqrt(varb)
																													         y_pop <- g_pop + e_pop
																														         phen <- data.table(gs[[pp]][,1:2], y_pop)
																															         varg <- var(g_pop)
																																         vare <- var(e_pop)
																																	         vary <- var(y_pop)
																																		         para <- data.table(Rep, M, S, h2, pop1, N, h2_2, varb, vg2, varg, vare, vary)
																																			         fwrite(para, file = "phenos/paras-VarPhen-Ss.txt", col.names = F, row.names = F, quote = F, append = T, sep = "\t")
																																				         fwrite(phen, file = paste0("phenos/caus", M, "-rep", irep, "-h2_", h2, "-S1_", S, "-", pop1, ".phen"), col.names = F, row.names = F, quote = F, sep = "\t")
																																					       }
																																					           }
																																						     }
																																						     }
																																						         

