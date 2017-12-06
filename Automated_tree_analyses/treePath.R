# define a distância entre quaisquer dois pontos (nó(s) e/ou tip(s)) de uma árvore no formato phylo (enraizada ou não)
# a distância é dada pelo número de ramos no caminho entre os dois pontos (default) ou pela soma dos comprimentos desses ramos (opção length.sensitive=TRUE)

# OBS: há funções similares disponíveis em pacotes do R, mas nenhuma das que testei funcionam para árvores não-enraizadas ou dão a distância correta entre nó e tip

treePath <- function(tree,a,b,length.sensitive=F){
	if(a==b){
		return(0)
		stop()
	}
	# identifica os pontos numericamente, caso um ou mais no input sejam taxons
	if(class(a)=="character"){
		a <- which(tree$tip.label==a)
	}
	if(class(b)=="character"){
		b <- which(tree$tip.label==b)
	}
	points <- c(a,b)
	# registra o caminho de cada ponto até o primeiro nó da árvore
	paths <- list(array(),array())
	lengths <- list(array(),array())
	for(i in 1:2){
		step <- points[i]
		len <- 0
		n <- 1
		repeat{
			paths[[i]][n] <- step
			lengths[[i]][n] <- len
			if(step==length(tree$tip.label)+1){
				break
			}
			len <- tree$edge.length[which(tree$edge[,2]==step)]
			step <- tree$edge[which(tree$edge[,2]==step),1]
			n <- n+1
		}
	}
	# a partir dos caminhos, define seu ponto de encontro (podendo inclusive ser a ou b)
	for(i in 1:length(paths[[1]])){
		for(j in 1:length(paths[[2]])){
			if(paths[[1]][i]==paths[[2]][j]){
				meet <- paths[[1]][i]
				break
			}
		}
		if(paths[[1]][i]==paths[[2]][j]){
			break
		}
	}
	# obtém a distância entre a e b somando as distâncias entre cada um e o ponto de encontro
	d <- -2
	dl <- 0
	for(i in 1:2){
		for(n in 1:length(paths[[i]])){
			d <- d+1
			dl <- dl+lengths[[i]][n]
			if(paths[[i]][n]==meet){
				break
			}
		}
	}
	if(length.sensitive==TRUE){
		return(dl)
	}
	else{
		return(d)
	}
}
