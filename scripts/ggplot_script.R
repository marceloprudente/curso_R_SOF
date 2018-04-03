
# baixar dados
dados_sociais <-read_csv2("dados_sociais.csv", 
                          locale = locale(encoding = "LATIN1"))

# criar variável 
dados_sociais$regiao <- substr(dados_sociais$uf, 1, 1)

# gráficos com a base do sistema

# Histograma
hist(dados_sociais$esp_vida)

# Diagrama de Caixas
with(dados_sociais, boxplot(esp_vida  ~factor(uf)))

# Barras
p <- table(ds$uf)
barplot(p)

# Dispersão
with(dados_sociais, plot(esp_vida, log(rdpc)))

## ggplot2
library(ggplot2)

# Histograma
qplot(esp_vida, data = dados_sociais)

# Boxplot
qplot(x = factor(uf),y = esp_vida, 
      data = dados_sociais, geom = "boxplot")

# Barplot
p <- table(dados_sociais$uf)
qplot(x = factor(uf), data = dados_sociais, 
      geom = "bar")

# Dispersão
qplot(x = esp_vida, y = log(rdpc), data = dados_sociais, 
      geom = "point") 

## ggplot
g <- ggplot(dados_sociais, aes(esp_vida, log(rdpc)) )
g

# especificar a camada geométrica
g + geom_point()

# se fosse uma linha
g + geom_line()

# especificar a cor dos pontos
g + geom_point(colour = "red")

# especificar a cor e o tamanho dos pontos
g + geom_point(colour = "red", size = 0.5)

# especificar os pontos de acordo com o tamanho da população
g + geom_point(colour = "blue", aes(size = pop) )

# as cores de acordo com os anos
g + geom_point(aes(colour = factor(ano))) 

# cores e tamanhos
g + geom_point(aes(colour = factor(ano), size = pop)) 

# Histogramas
p <- ggplot(dados_sociais, aes(x = esp_vida))
p + geom_histogram(color = "blue", fill = "green")

## Histogramas 2
p <- ggplot(dados_sociais, aes(x = esp_vida))

p + geom_histogram(color = "blue", fill = "green") +
  geom_freqpoly( size = 1)


## Densidade
p <- ggplot(dados_sociais, aes(x = esp_vida))
p + geom_density(color = "red", fill = "yellow")

## stat_summary()

# é possível sumarizar os dados antes
library(dplyr)
rdpc_uf <- dados_sociais %>% 
  group_by(uf) %>%
  summarise(rdpc = mean(rdpc))

# depois, fazer um gráfico
ggplot(rdpc_uf, aes(factor(uf), rdpc)) + 
  stat_sum( geom = "bar")

# é possível fazer o gráfico diretamente
dados_sociais %>%
  ggplot(aes(factor(uf), rdpc)) +
  stat_summary(fun.y = "mean", geom = "bar")

# desagrupar dados
graf <- dados_sociais %>% 
  ggplot(aes(esp_vida, rdpc, color = factor(ano)) ) + 
  geom_point() 
graf

# criar plot de base
dados_sociais %>% 
  ggplot(aes(x = ano, y = rdpc, color = factor(regiao)) ) + 
  stat_summary(fun.y = "mean", geom = "line") 

# aumentar largura da linha
dados_sociais %>% 
  ggplot(aes(x = ano, y = rdpc, color = factor(regiao)) ) + 
  stat_summary(fun.y = "mean", geom = "line", size = 2) 


g4 <- dados_sociais%>% 
  ggplot(aes(x = regiao, y = tx_analf_15m, fill = as.factor(ano)))+ 
  stat_summary(fun.y = "mean", 
               geom = "bar", position = "dodge") 
g4


## facet()
p <- dados_sociais %>%
  ggplot(aes(esp_vida, rdpc)) + geom_point() 
# facet em um mesma grade de imagem
p + facet_grid(. ~ regiao)

# facet wrap - com mais colunas
p + facet_wrap( ~ regiao, ncol = 2)


## camadas de ajuste
graf <- graf + 
  labs( title = "Renda x Esp Vida", 
        x = "Esperança de Vida", 
        y = "Renda per capita", 
        color = "Anos")
graf

# temas
graf +  theme_minimal()

