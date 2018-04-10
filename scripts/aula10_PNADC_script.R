# Aula 10 - script
#######################
#### PNAD Contínua ####
#######################

# ver também: http://api.rpubs.com/BragaDouglas/335574
# srvyr: https://cran.r-project.org/web/packages/srvyr/vignettes/srvyr-vs-survey.html
# convey: https://guilhermejacob.github.io/context/


# instalar pacote
install.packages("PNADcIBGE")

# carregar pacotes
library(PNADcIBGE)
library(survey)
library(srvyr)

# baixar pnad contínua trimestral
pnadc = get_pnadc(year = 2017, quarter = 4)

# classe
class(pnadc)

# transformar em tbl_svy
pnadc <- as_survey(pnadc)

# baixar pnadc anual: especificar o ano e a entrevista
pnadc_anual = get_pnadc(year = 2016, interview = 1)

###############################
## Carregando dados Off-line ##
###############################

# diretório
setwd("C:/dados/PNADC")

# baixar dados
dados_pnadc <- read_pnadc("PNADC_042017.txt", "Input_PNADC_trimestral.txt")

# incluir rótulos
dados_pnadc <- pnadc_labeller(dados_pnadc, "dicionário_das_variáveis_PNAD_Continua_microdados.xls")

# desenho de survey
dados_pnadc <- pnadc_design(dados_pnadc)

# transformar em tbl_svy
dados_pnadc <- as_survey(dados_pnadc)

###########################
## Transformando tabelas ##
###########################

# renda por sexo e raca
tot_sexo_raca <- pnadc %>% 
  group_by(V2007, V2010) %>%
  summarise(total = survey_mean(VD4016, na.rm = T))

##########
# spread #
##########
library(tidyr); library(tidyverse)

# reorganizar a tabela
tot_sexo_raca <- tot_sex_raca %>% 
  select(V2007:total) %>% 
  spread(V2007, total)

# gather
tot_sexo_raca <- gather(r, V2007, value, - V2010)

########################
## Teste de Hipóteses ##
########################

# VD4020 - renda
# V2007 - sexo
svyttest(VD4020 ~ V2007, dadosPNADc_anual)

######################
## modelos lineares ##
######################
# o  ~ separa a variável dependente das independentes
modelo <- svyglm(VD4020 ~ VD3001 + V2010 + V2009 + V2007, dadosPNADc_anual)
summary(modelo)

## Regressões Logísticas
modelo <- svyglm(V3007 ~ V2007 + V2010 + V2009 + regiao, 
                 dadosPNADc_anual, family = "binomial")
summary(modelo)

############
## convey ##
############
install.packages("convey")
library(convey)

# tornar dados para "convey.design"
pnadc <- convey_prep(pnadc)

# gini renda brasil
gini <- svygini(~VD4020, dadosPNADc_anual, na.rm  =  TRUE)
gini

# gini renda uf
giniUF <- svyby(~VD4020, by = ~UF, 
                dadosPNADc, svygini, na.rm  =  TRUE)
giniUF

# gini renda região
gini_regiao <- svyby(~VD4020, by = ~ regiao, 
                     dadosPNADc_anual, svygini, na.rm  =  TRUE)
gini_regiao


