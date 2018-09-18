# Manipulação de dados com *dplyr*

## limpar ambiente global
rm(list = ls())

## Primeiro passo: fixar diretório
setwd("C:/curso_r/dados")

## Segundo passo: utilizar pacotes
library(tidyverse)

## Terceiro passo: carregar dados sociais
ds <- fread("dados_sociais.csv", 
            dec = ',')

## Quarto passo passo: analisar os dados
glimpse(ds)
summary(ds)

# Verbos do *dplyr*----

## filter: selecionar linhas

## apenas ano 2000
ds_2000 <- filter(ds, ano == 2000)
## apenas municipio de aracaju
ds_ara <- filter(ds, 
                        municipio == "ARACAJU")
## ou municipio de São Paulo
ds_sp <- filter(ds, municipio == "SÃO PAULO")

## ano 1991 ou 2000, estado de são paulo e esperança de vida maior que 70 anos
ds2 <- filter(ds, (ano == 2000  | ano == 1991) &
         uf == 35 & 
         esp_vida >= 70) 
