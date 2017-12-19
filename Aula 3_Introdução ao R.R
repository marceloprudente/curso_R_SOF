# Básico
#-------------------------------------------------------------------------#
### Operadores aritméticos - interagindo com o interpretador

1 + 2 # adição
15 - 8 # subtração
4*10 # multiplicação
27/3 # divisão
2^5  # exponenciação
4^1/2 # raiz quadrada

# precedência dos operadores
4^2 - 3*2
(4^2) - (3*2) # use os parênteses para agrupar, clarificar

1 - 5 + 7 
(1 - 5) + 7 # idêntico, porém mais claro

4 + 3^2
(4 + 3)^2

-2--3
-2 - -3 # usar espaços para maior clareza

# Funções
log(100) # logarítmo natural
log(100, base=10) # logarítimo base-10
log10(100) # equivalente
log(100, b=10)  # abreviação do argumento

sqrt(144) # raiz quadrada
144^(1/2) # mesmo

# Argumentos para as funções
args(log) 
args(sqrt)

#  Obtendo ajuda e informação


help("log")    # documentação
?log           # o mesmo
example("log") # executa os examplos da página de ajuda


apropos("log") # acha todos os objetos contendo a palavra log
help.search("log") # procura mais informações sobre a função log

RSiteSearch("loglinear", "functions") # procura mais informações no site do R

`+`(2, 3) # ficar atento, pois até os operadores são funções

#---------------------------------------------------------------------------#
### Operadores lógicos
2 <= 2 # menor ou igual
2 == 1.999 # igual
2 == 1.99999999999999999 # igual
20 != 20 # diferente
!TRUE # não é verdadeiro
TRUE | FALSE # OU
FALSE | FALSE # OU
TRUE & FALSE # E
TRUE & TRUE # E
TRUE & TRUE & FALSE
xor(TRUE, TRUE) # outra maneira
xor(TRUE, FALSE)
TRUE == 1 # o operador lógico é binário
TRUE == 2
FALSE == 0

TRUE & c(TRUE, FALSE)                        # Lógico E
c(TRUE, FALSE, FALSE) | c(TRUE, TRUE, FALSE) # Lógico OU
TRUE && FALSE  # E não vetorizado (para programação)
TRUE || FALSE  # OU não vetorizado

! c(T, F)   # abreviações de Verdadeiro e Falso


3 <= 4 | 1 == 2


#-------------------------------------------------------------------------#
## if, else e else if
# Exemplo de aplicação dos operadores lógicos (usando if)
age <- 16
if (!(age > 18)) {
  print("You are Too Young")
} else if(age > 18 && age <= 35) {
  print("Young Guy")
} else if(age == 36 || age <= 60) {
  print("You are Middle Age Person")
} else {
  print("You are too Old")
}

### Números complexos
x <- 5

# teste: x é número?
is.numeric(x)
# teste: x NÃO é um número?
!is.numeric(x)
# teste: x é menor que zero?
x < 0
# teste: x é maior que zero?
x > 0

if(!is.numeric(x)) {
  "x não é um número"
} else if(x > 0) {
  "x é positivo"
} else if(x < 0) {
  "x é negativo"
} else {
  "x é nulo"
}

# Criando vetore

c(1, 2, 3, 4)  # combine 

1:4     # operador de sequencias
4:1
-1:2    # atenção à precedência
-(1:2)  

seq(1, 10) # tb cria uma sequencia de números
seq(1, 15, by=2) # especifica o intervalo
seq(0, 1, by=0.1) # uma sequencias de números racionais
seq(0, 1, length=11) # especifica o número de elementos no intervalo

# Aritmética vetorial

c(1, 2, 3, 4)/2
c(1, 2, 3, 4)/c(4, 3, 2, 1)
log(c(0.1, 1, 10, 100), 10)

c(1, 2, 3, 4) + c(4, 3) # sem "warning"
c(1, 2, 3, 4) + c(4, 3, 2) # com "warning"

# Criando variáveis por atribuição

x <- c(1, 2, 3, 4) # atribuição
x # print

x = c(1, 2, 3, 4) # é possível utilizar = para atribuição (mas é melhor evitar)
x

x/2            # equivalente a c(1, 2, 3, 4)/2
(y <- sqrt(x)) # os parênteses podem ser utilizados para mostrar os dados diretamente

(x <- rnorm(100)) # cria um vetor com distribuição normal
head(x) # apresenta os primeiros elementos do vetor
summary(x)  # uma função genérica do sistema

# character e logical data

(palavras <- c("Curso", "R", "para", "Analistas", "da", "SOF"))
paste(palavras, collapse=" ") # junta palavras e números

(logicos <- c(TRUE, TRUE, F, T))
!logicos # podemos negar os valores lógicos

# Transformando a classe dos dados - coercion

sum(logicos)      # apresenta o número de valores verdadeiros (TRUE == 1, FALSE== 0)
sum(!logicos)     # apresenta o número de falsos
c("A", FALSE, 3.0)       # coerced to character

c(10, FALSE, -6.5, TRUE) # coerced to numeric




# Working directory
getwd()

setwd("... caminho da pasta")

# Carregar dados
caminho_local <- "ToothGrowth.csv"
dados <- read.csv(caminho_local)

caminho_da_internet <- "https://raw.githubusercontent.com/Athospd/bds/master/csv/ToothGrowth.csv"
download.file(caminho_da_internet, 'teste.csv', method = 'wget')
dados <- read.csv(caminho_da_internet)

str(dados)
View(dados)

# Pacotes
?not

install.packages("magrittr")
library(magrittr)
?not


#-------------------------------------------------------------------------#
## for

frutas <- c("banana", "uva", "abacaxi")

# Brincadeira da <fruta> + "guei"
for(fruta in frutas) {
  print(paste(fruta, "guei", sep = ""))
}

# repare nos []'s depois do vetor 'frutas'
for(i in 1:length(frutas)) {
  print(paste(frutas[i], "guei", sep = ""))
}

# seq_along() é uma função especialmente útil para for's
for(i in seq_along(frutas)) {
  print(paste(frutas[i], "guei", sep = ""))
}


# Exemplo simples de quando é util utilizar índice em vez de valor.
frutas1 <- c("banana", "uva", "abacaxi")
frutas2 <- c("kiwi", "uva", "laranja")
pessoas <- c("Amanda", "Bruno", "Caio")

for(i in seq_along(frutas1)) {
  if(frutas1[i] == frutas2[i]) { # frutas iguais?
    frutas1[i] <- "manga" # Troca a fruta 1
    print(paste(pessoas[i], "ganhou frutas repetidas. Uma delas foi trocada por manga."))
  } # if
} # for


### *ifelse()*: *for* com *if else*

frutas1 <- c("banana", "uva", "abacaxi")
frutas2 <- c("kiwi", "uva", "laranja")
pessoas <- c("Amanda", "Bruno", "Caio")

frutas1 <- ifelse(frutas1 == frutas2, "manga", frutas1)

#-------------------------------------------------------------------------#
## while

p <- 0.2 # probabilidade de cair "cara"
lances <- 0 # contador de lançamentos
while(runif(1) > p) {
  lances <- lances + 1
}

lances


modelo <- glm(Sepal.Length ~ Species, data = iris)
# Número de iterações de Escore de Fisher é um exemplo de convergência
summary(modelo)

#-------------------------------------------------------------------------#
## Vetorização

x <- 1:1000000 # sequência de inteiros de 1 a 1000000

# função que calcula a raiz quadrada de cada elemento de um vetor de números
meu_sqrt <- function(numeros) {
  resp <- numeric(length(numeros))
  for(i in seq_along(numeros)) {
    resp[i] <- sqrt(numeros[i])
  }
  return(resp)
}

# Comparação de eficiência entre função vetorizada e função "vetorizada no R"
system.time(x2a <- meu_sqrt(x))
system.time(x2b <- sqrt(x))

# Verifica que os dois vetores são iguais
identical(x2a, x2b)

# Matriz 2x2
A <- matrix(1:4, 2)
diag(A)
diag(3)
diag(c(1,2,10,-1))

#-------------------------------------------------------------------------#
## Reciclagem

x <- c(1,5)
y <- c(1,10,100,1000)
x + y

#-------------------------------------------------------------------------#
## Funções

ecoar <- function(palavra, n_ecos = 3) {
  paste(c(rep(palavra, n_ecos), "!"), collapse = " ")
}

# Função que desenha um histograma
histograma <- function(numeros, xlab = "x", titulo = paste("Histograma de", xlab)) {
  hist(numeros, xlab = xlab, main = titulo)
}

# Simula 1000 medidas de altura de pessoas de uma Normal com média 1,80 e desvio padrão de 0,1.
altura <- rnorm(n = 1000, mean = 1.80, sd = 0.1)
histograma(altura, "altura")
histograma(altura, "altura", "Eu escolho o título que eu quiser")

### Parâmetro "..."
histograma <- function(numeros, xlab = "x", titulo = paste("Histograma de", xlab), ...) {
  hist(numeros, xlab = xlab, main = titulo, ...)
}

args(paste)

paste("Eu", "sou", "o", "capitão", "planeta")

histograma(altura, breaks = 100, col = 2)

### Funções anônimas

nums <- 1:10

eh_par <- sapply(nums, function(numero) {numero %% 2 == 0})

cbind(nums, eh_par)


testa_se_eh_par <- function(numero) {
  numero %% 2 == 0
}

eh_par <- sapply(nums, testa_se_eh_par)

### Escopo
x <- pi

f <- function(x) {
  g <- function(y) {
    2*y + x
  }
  
  g(x)
}

f(10)
g(10)

f <- function(x) {
  y <- 1000
  g <- function(y) {
    2*y + x
  }
  
  g(x)
}

f(10)

f <- function(x) {
  y <- 1000
  g <- function(z) { # troca y por z
    2*y + x
  }
  
  g(x)
}

f(10)

f <- function(w) { # troca x por w
  y <- 1000
  g <- function(z) {
    2*y + x
  }
  
  g(x)
}

f(10)

#-------------------------------------------------------------------------#
## Variáveis Aleatórias

x <- seq(-3,3,l=100)
d <- dnorm(x) # densidade
plot(x, d, ylim=c(0,1))

p <- pnorm(x) # probabilidade acumulada
lines(x, p)

q <- qnorm(p) # inverso de pnorm
mean((x-q)^2) # igual a zero

n <- 100000
r0 <- rnorm(n, mean = 0, sd = 1)
r1 <- rnorm(n, mean = 1, sd = 1)
hist(r0, freq = FALSE, add=TRUE, breaks=100, col=rgb(0,0,1,.2))
hist(r, freq = FALSE, add=TRUE, breaks=10, col=rgb(1,0,0,.2))