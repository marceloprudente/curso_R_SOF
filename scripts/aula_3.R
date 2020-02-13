# Manipulação de dados com dplyr
# Lembre-se dplyr faz parte do tidyverse

## vamos limpar ambiente global
rm(list = ls())

## Qual o diretório atualmente ativo?
getwd()

## Primeiro passo: fixar diretório
## (se não for o diretório ativo)
setwd("C:/curso_r/dados")

## Segundo passo: utilizar pacotes
library(tidyverse)
library(data.table) # para fread()

## Terceiro passo: carregar dados sociais
ds <- fread("dados_sociais.csv", 
            dec = ',')

## Quarto passo passo: analisar os dados
glimpse(ds) # ver estrutura dos dados
summary(ds) # sumário dos dados

#######################
# Verbos do *dplyr*----
#######################


## 1) filter: selecionar linhas

### apenas ano 2000
ds_2000 <- filter(ds, ano == 2000)

### apenas municipio de aracaju
ds_ara <- filter(ds, 
                 municipio == "ARACAJU")

### ou municipio de São Paulo
ds_sp <- filter(ds, 
                municipio == "SÃO PAULO")

## ano 1991 ou 2000, estado de são paulo e esperança de vida maior que 70 anos
ds2 <- filter(ds, (ano == 2000  | ano == 1991) &
                uf == 35 & 
                esp_vida >= 70) 

## Exercício: observe o banco dados_sociais tal que:
### o ano seja igual a 2010
### a taxa de analfabetismo seja maior que a média
### o estado seja do nordeste
### as UFs do NE começam com o número 2
ds_e1<- filter(ds, ano == 2010 &
               tx_analf_15m >= mean(tx_analf_15m) &
                (uf >= 20 & uf <30 ))

### verificar se selecionei NE
### funcao table
table(ds_e1$uf)

### como filtrar texto
ds_sao<-filter(ds, grepl("São", municipio,
                         ignore.case = TRUE))

# sensível a maiúsculas e minúsculas
a1<- filter(ds, grepl("Ara", municipio))
a2<- filter(ds, grepl("ARA", municipio, 
                      ignore.case = TRUE ))


# regex
# podemos utilizar as Expressões Regulares - regex
# verificar apostila aula 3 - página 8
a3 <- filter(ds, grepl("^São José de", municipio, 
           ignore.case = TRUE))

#############################################
## 2) select(): para selecionar colunas ----

### selecionar 3 colunas
ds_select <- select(ds, ano, uf, rdpc)

### mostrar primeiras linhas
head(ds_select)

### retirar colunas - use o "-"
ds_select2 <- select(ds, -rdpc, - pop)
head(ds_select2)

### selecionar com base em um vetor character
nome <- c("ano", "uf", "pop")
ds_select3 <- select(ds, nome)
head(ds_select3)

### selecionar primeras colunas
### retirar variável código ibge
ds_select4 <- select(ds, ano:municipio)
head(ds_select4)

### selecionar intervalo de colunas 
### de acordo com a posicao
ds_select5 <- select(ds, 1:5)
head(ds_select5)

### selecionar cadeia, exceto 1
ds_select6 <- select(ds, ano:municipio, -cod_ibge)
head(ds_select6)

### reordenar
ds_select7 <- select(ds, 5:8, 1:4)
head(ds_select7)

### podemos reordernar e depois
### utilizar o "select helper" 
### everything()
ds_select8 <- select(ds, pop, everything())
head(ds_select8)

### SELECT HELPERS

?select_helpers # veja o help!

### vamos baixar os dados do sus
sihsus <- read.dbc::read.dbc("RDSE1701.dbc")
glimpse(sihsus)
summary(sihsus)

### selecionar colunas que começam com VAL
### portanto, starts_with
sihsus_2 <- select(sihsus, 1:5,
                   starts_with("val"))
summary(sihsus_2)
### selecionar colunas que contém letra "H"
### portanto, contains
select(sihsus, contains("H"))

### RENOMEAR
### a ordem importa
### primeiro o nome que você quer dar
### depois a variavel a ser renomeada
rename(ds, ANO = ano)

#################################
#### PIPE - seu melhor amigo ----
#################################

x <- 1:20
# forma tradicional
round(log(x), 2)

# com o pipe
x %>% log() %>% round(2)

# pipe com dplyr
ds_e2 <- ds %>% 
  select(ano, uf, rdpc) %>% 
  filter(ano == 2010)

# arrange
ds_e2 <- ds %>% 
  select(ano, uf, rdpc) %>% 
  filter(ano == 2010) %>% 
  arrange(-uf)
head(ds_e2)

# exemplo 1
# ordenando por duas variáveis
ds_e3 <- ds %>% 
  select(ano, uf, rdpc, pop) %>% 
  filter(ano == 2010) %>% 
  arrange(-uf, -pop) 
head(ds_e3)

# exemplo 2
# incorporando o head
ds %>% 
  select(ano, uf, rdpc, pop) %>% 
  filter(ano == 2010) %>% 
  arrange(-pop) %>% 
  head(10)

###################################
# mutate(): criar novas variaveis #

# o mutate cria novas variáveis veja

# exemplo 1: criar população ao quadrado
ds %>% 
  select(ano, uf, pop) %>% 
  mutate(pop2 = pop^2) %>% 
  head()

# exemplo 2: criar novas variávies
ds_3 <- ds %>% 
  select(ano, uf, rdpc, pop) %>% 
  filter(ano == 2010) %>%
  mutate(renda_total = rdpc * pop, 
         log_pop = log(pop),
         renda_sq = renda_total ^ 2)

#####################################################
## group by e summarise: esqueca tabelas dinâmicas ##

esp_vida <- ds %>% 
  group_by(ano, uf) %>% 
  summarise(media = mean(esp_vida),
            mediana = median(esp_vida),
            populacao = sum(pop))

##############################
## Join(): melhor que procv ##
##############################
df1 <- tibble(letras = letters[1:8],
              num_a = 1:8 )

df2 <- tibble(letras = letters[5:12], 
              num_b = 5:12)

df3 <- tibble(LETRAS = letters[5:20], 
              num_c = 5:20)

# junção natural
mesclado1 <- inner_join(df1, df2)

# junção natural
# preferível espeficicar chave
mesclado1 <- inner_join(df1, df2,
                        by = "letras")

# não funciona: precisa identificar chave
mesclado2 <- inner_join(df1, df3)

# funciona: identifica as chaves
inner_join(df1, df3, 
           by = c("letras" = "LETRAS"))

# full_join()
mesclado_full <- full_join(df1, df3, 
                           by = c("letras" = "LETRAS"))
mesclado_full

# left_join()
left_join(df1, df3, 
          by = c("letras" = "LETRAS"))
mesclado_left

# right_join()
right_join(df1, df3, 
           by = c("letras" = "LETRAS"))
mesclado_right

# anti_join()
anti_join(df1, df3, 
          by = c("letras" = "LETRAS"))
mesclado_anti1

# modificando a posição dos bancos
mesclado_anti2 <- anti_join(df3, df1, 
                            by = c("LETRAS" = "letras"))
mesclado_anti2


#####################
## OUTRAS FUNÇÕES  ##
#####################

fies <- data.table::fread("fies_sample.csv",
                          dec = ",")

# encontrar número de valores duplicados
fies %>% 
  select(CO_CONTRATO_FIES) %>% 
  duplicated() %>% 
  sum()
# encontrar número de contratos distintos?
fies %>% 
  summarise(unicos = n_distinct(CO_CONTRATO_FIES))

# podemos agrupar os contratos por estados
# e visualizar sua distribuição
fies %>% 
  group_by(SG_UF) %>% 
  summarise(unicos = n_distinct(CO_CONTRATO_FIES)) %>% 
  arrange(-unicos)

# Exemplo com 1500 linhas
fies2 <- fread("fies_sample.csv", 
               nrows =  1500)
# mostrar o total de contratos repetidos
# e contar em cada grupo a ordem de repeticao
# dos contratos
fies2 <- fies2 %>% 
  group_by(CO_CONTRATO_FIES) %>% 
  mutate(
    total = n(),
    repetidos = 1:n()) %>% 
  select(CO_CONTRATO_FIES, repetidos, total) %>% 
  filter(repetidos == 1)

# selecionar apenas contratos unicos
# note que a primeira forma retorna apenas
# a coluna especificada
fies_sub <- fies %>% 
  distinct(CO_CONTRATO_FIES)

# para observarmos todas as colunas,
# utilizamos o comando ".keep_all = TRUE"
# com o pontinho na frente mesmo
fies_sub <- fies %>% 
  distinct(CO_CONTRATO_FIES, .keep_all = TRUE)


## CONTAR OBSERVAÇÕES NO BANCO: n()
## o comando "n()" é muito útil. 
## veja só:

## contar contratos por sexo e raca
fies_sexo_raca <- fies_sub %>% 
  group_by(DS_SEXO, DS_RACA_COR) %>% 
  summarise( total = n())

## e o percentual?
## para encontrar o percentual,
## basta dividir o total pela soma do total
fies_sexo_raca <- fies_sub %>% 
  group_by(DS_SEXO, DS_RACA_COR) %>% 
  summarise( total = n()) %>% 
  mutate(percentual = total/sum(total))

## desagrupando
## da mesma forma que agrupamos,
## podemos desagrupar as variáveis
## isso modifica os resultados
## tente entender a lógica por trás disso
fies_sexo_raca <- fies_sub %>% 
  group_by(DS_SEXO, DS_RACA_COR) %>% 
  summarise( total = n()) %>% 
  ungroup() %>% 
  mutate(percentual = total/sum(total))

# apenas por sexo e desagrupando
fies_sexo_raca <- fies_sub %>% 
  group_by(DS_SEXO) %>% 
  summarise( total = n()) %>% 
  ungroup() %>% 
  mutate(percentual = total/sum(total))

## filtando sexo sem resposta
## ou seja, não queremos que as não respostas
# contaminem nossa análise
fies_sub %>% 
  filter(DS_SEXO != "") %>% 
  group_by(DS_SEXO) %>% 
  summarise( total = n()) %>% 
  mutate(percentual = total/sum(total))

###########
# top_n() #
###########

## essa é uma forma rápida de filtrar os dados

# 10 maiores mensalidades
fies_sub %>% 
  group_by(DS_CURSO) %>% 
  summarise(valor_medio = mean(VL_MENSALIDADE, na.rm = TRUE)) %>% 
  top_n(10, valor_medio) %>% 
  arrange(-valor_medio)

# 10 cursos com mais contratos
fies_sub %>% 
  filter(DS_CURSO != "") %>% 
  group_by(DS_CURSO) %>% 
  summarise(total_contratos = n()) %>% 
  top_n(10, total_contratos) %>% 
  arrange(-total_contratos)
  
################## 
# Criar booleano #
##################

# qual a media mensalidade no pais
med <- fies_sub %>% 
  summarise(media = mean(VL_MENSALIDADE, na.rm = T)) %>% 
  pull() # pull literalmente puxa o valor desejado
med
class(med)# o pull transforma isso em vetor

## mensalidade uf
fies_sub %>% 
  group_by(SG_UF) %>% 
  summarise(media = mean(VL_MENSALIDADE, na.rm = TRUE)) %>% 
  mutate(acima_med = ifelse(media > med , 1 ,0))

## agora ifelse nomeando categoria
fies_sub %>% 
  group_by(SG_UF) %>% 
  summarise(media = mean(VL_MENSALIDADE, na.rm = TRUE)) %>% 
  mutate(acima_med = ifelse(media > med , 1 ,0), 
         acima_med2 = ifelse(media > med , "Acima" ,"Abaixo"))
## podemos colocar um ifelse dentro de outro
## nested ifelse
## mas isso torna o código mais complicado
fies_sub %>% 
  group_by(SG_UF) %>% 
  summarise(media = mean(VL_MENSALIDADE, na.rm = TRUE)) %>% 
  mutate(acima_med = ifelse(media > mean(media), 1 ,0),
         ac_med2 = ifelse(media > mean(media), "Acima da média", "Abaixo da Média"), 
         ac3 = ifelse(media < 900, 1,
                      ifelse(media > 1000, 3, 2)))

############
# any()----

# alguma das informações obedece ao critério X?
df_na <- tibble(letras = LETTERS[1:11],
                idade = c(seq(10, 80, 10), NA, NA, NA))

# alguma observacao do banco é NA?
any(is.na(df_na))

# baixar os dados
dom <- read_csv2("C:/curso_r/dados/dados_domiciliares.csv", 
                 locale = locale(encoding = "Latin1"))

# olhar os dados
glimpse(dom)

# nome das colunas
colnames(dom)

# alguém do domicilio é idoso?
dom <- dom %>% 
  group_by(domicilio) %>% 
  mutate(dom_idoso = ifelse(any(idade >= 50), 
                            "Dom. tem idoso", "Não tem idoso"))

## quantos domicílios tem idosos
## vamos usar o "count()"
## é uma forma simples de utilizar o "n()"
## tente "?count()"
dom %>% 
  distinct(dom_idoso , .keep_all = TRUE) %>% 
  group_by(dom_idoso) %>% 
  count()

############
# cut() ----

# podemos cortar uma distribuicao em classes
x = 1:10
cut(x, 2)

# podemos especificar os rótulos
cut(x, 2, labels = c("a", "b"))

cut(x, 3, labels = c("a", "b", "c"))

# podemos especificar outros intervalos
cut(x, c(0, 5, 10))
cut(x, c(0, 5, 10), 
    labels = c("0 - 5", "6 - 10"))

# cortar as idades em intervalos de 5 anos
dom <- dom %>% 
  mutate( idade_cut = cut(idade, seq(0,100, 5)))

# criamos a funcao age_cat
## ele é um script igual aos outros
## baixe usando source
source('age_cat.R')

# cortar usando age.cat
args(age.cat)

## aplicando com mutate
dom <- dom %>% 
  mutate(age_cat = age.cat(idade, upper = 90, by = 5))

###############
# paste() ----
# concatenar informacoes

# Irmãos Peixoto
irmaos <- c("Edgar", "Edclésia", 
            "Edmar", "Edésia", "Edésio")

# Como colocar os sobrenomes?
paste(irmaos, "Peixoto")
paste(irmaos, "Peixoto", sep = ",")
paste(irmaos, "Peixoto", sep = "")
paste0(irmaos, "Peixoto")

# uso do paste
x = 1:10
y = 51:60
paste(x, y)
paste0(x, y)
paste(x, y, sep = ".") %>% as.numeric()
paste0(x, y) %>% as.numeric()

## uso do paste no dplyr
dom <- dom %>% 
  mutate(sexo_cor = paste(sexo, "-", cor)) 

head(dom$sexo_cor)

## agrupado
dom %>% 
  group_by(sexo_cor) %>% 
  count()

# substr(): cortar dados
x = "palavra"
substr(x, 1, 1)
substr(x, 1, 2)
substr(x, 3, 4)
substr(x, 3, nchar(x))

###############
## gsub() ----
## substituir strings
## funcionamento do gsub
gsub("-", "@", "curso-hotmail.com")

# exemplo com números
# quando o decimal é importado errado
x = c("3,8", "4,9", "5,5")
as.numeric(x)
gsub(",", ".", x) %>%  as.numeric()

# aplicando a um data.frame
dom %>% 
  mutate(sexo_cor2 = gsub("-", "@", sexo_cor)) %>% 
  select(sexo_cor2) %>%  #selecionar variável de interesse
  head(10) # mostrar 10 primeiros

#####################
# lead() e lad() ----
x = 1:10
# uma defasagem
lag(x)
# duas defasagens
lag(x, 2)

# adiantar uma vez 
lead(x)

# adiantar duas vezes
lead(x, 2)

# criar uma série
df = tibble(a = rep(1:5, 3), 
            b = rnorm(15, 15, 10))

# lead e lag
df %>% 
  mutate(c = lead(b, 1), 
         d = lag(b, 2))

# lead e lag comd dados sociais
TO <- ds %>% 
  filter(uf == "11") %>% 
  select(ano:municipio, rdpc)

# exibir primeiras linhas
head(TO)

# lead
TO <- TO %>%  ungroup %>% 
  group_by(cod_ibge) %>% 
  mutate(lag_rdpc = lag(rdpc), 
         var_rdpc = (rdpc - lag_rdpc)/ lag_rdpc,
         var_rdpc_pec = paste(round(var_rdpc*100, 2), "%"))

## Lidando com NAs
df_na <- tibble( letras = LETTERS[1:10],
                 idade = c( seq(25L, 40L, 5L), NA,
                            NA, 32L, rep(NA, 3)))
# é possível saber se um vetor é NA
is.na(df_na)
# Também é possível remover esses valores
na.omit(df_na)


# Substituindo NAs por números
replace_na(df_na, list(idade = 0))
# Substituindo NAs por textos
replace_na(df_na, list(idade = "Idade não informada"))


## Quantile

## calcular quintis
quantile(dom$idade)

# calcular decis
quantile(dom$idade, seq(0.1, 1, 0.1))

# ntile() - funçao de decis do dplyr
dom <- dom %>%
  ungroup() %>% # desagrupa os dados
  mutate(quintil = ntile(idade, 5),
         decil = ntile(idade, 10))
# todos os grupos tem mesmo tamanho
dom %>%
  group_by(decil) %>%
  count()
# TRABALHAR COM DATAS
# PACOTE lubridate
library(lubridate)

# ano, mês e dia sem separador
ymd("20180131")

# mês, dia e ano com separador "-"
mdy("01-31-2018")

# dia, mês e ano com separador "/"
dmy("31/01/2018")

# funciona se o mes estiver por extenso
dmy("30jun2020")

# criamos um vetor com datas mes (m) e ano (y)
datas <- c("01/2014", "03/2016")

# adicionamos o dia (d) com o paste0
dmy(paste0("01", datas))

# criar um vetor de datas
datas<- ymd(c("20180131", "20170225", "20160512"))
# quais os anos
year(datas)

# quais os anos
month(datas)



tail(TO)