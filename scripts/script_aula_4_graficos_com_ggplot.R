
# carregar dados
dados_sociais <-read_csv2("C:/curso_r/dados/dados_sociais.csv", 
                          locale = locale(encoding = "LATIN1"))
# criar variável para regiao
dados_sociais$regiao <- substr(dados_sociais$uf, 1, 1)




## Gráficos com a base do sistema

# Histograma
hist(dados_sociais$esp_vida)
# Diagrama de Caixas
with(dados_sociais, boxplot(esp_vida  ~factor(uf)))
# Barras
p <- table(ds$uf)
barplot(p)
# Dispersão
with(dados_sociais, plot(esp_vida, log(rdpc)))


## Quick plots com ggplot()


library(ggplot2) # caso não tenha sido carregado ainda
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

## Gráficos com ggplot2()

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


### Criar subgráficos com o facet()

## facet()
p <- dados_sociais %>%
  ggplot(aes(esp_vida, rdpc)) + geom_point() 
# facet em um mesma grade de imagem
p + facet_grid(. ~ regiao)
# facet wrap - com mais colunas
p + facet_wrap( ~ regiao, ncol = 2)

### Camadas de ajustes no ggplot

# elaborar gráfico
graf <- dados_sociais %>% 
  ggplot(aes(esp_vida, rdpc, color = factor(ano)) ) + 
  geom_point(shape = 1) 
# aplicar títulos
graf <- graf + 
  labs( title = "Renda x Esperança de Vida", 
        caption = "Fonte: IBGE. Elaboração própria",
        x = "Esperança de Vida", 
        y = "Renda per capita", 
        color = "Anos")
graf
# Ajustar escalas
graf <- graf + 
  scale_x_continuous(breaks = seq(50, 80, 5),
                     labels = function(x) paste(x, "anos")) +
  scale_y_continuous(breaks = seq(0, 3000, 250), 
                     labels = function(x) paste("R$", x)) +
  scale_color_manual(values = c("darkolivegreen1", "steelblue", "brown2"))
graf
# Configurar temas
graf +  theme_minimal()
graf +  theme(
  plot.title = element_text(hjust=0.5, face="bold"),
  plot.background=element_rect(fill="white"),
  panel.background=element_rect(fill="white"),
  panel.grid.minor= element_line(color = "gray60"),
  panel.grid.major.y=element_line(color = "gray60"),
  panel.grid.major.x=element_line(color = "gray60"),
  axis.ticks=element_blank(),
  legend.position="bottom")
