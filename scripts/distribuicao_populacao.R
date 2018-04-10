# Gráfico distribuição da população

# baixar função faixas etárias

# preparar dados: criar faixa etária
dadosPNADc_anual <- dadosPNADc_anual %>%
  mutate(fx_idade = age.cat(V2009, 0, 80, by = 5))

# segregar população por sexo e faixa etária
t <- dadosPNADc_anual %>% 
  group_by(V2007, fx_idade) %>% 
  summarize(pop = survey_total( na.rm = TRUE)) %>%
  mutate(total = sum(pop),
         perc = (pop/total)*100, 
         perc = ifelse(V2007 == "Mulher", perc, perc*-1))

# adicionar um pequeno valor ao percentual - será nosso rótulo
t$perc2 <- ifelse(t$perc >0, t$perc +0.3, t$perc -0.3)

#################
#### gráfico ####
#################

# camada básica
p <- ggplot(data = t, aes(x = fx_idade, y = perc , fill = V2007))

# adicionar barras para homens
p <- p +  geom_bar(data = subset(t, V2007 == "Homem"), stat = "identity")

# adicionar barra para as mulheres

p <- p +  geom_bar(data = subset(t, V2007 == "Mulher"), stat = "identity") 

# ver o gráfico
p

# girar o eixo do gráfico
p <- p +   coord_flip() 

# mudar a escala de y (que agora é horizontal)
p <- p +  scale_y_continuous(breaks = seq(-5, 5, .5), 
        # colocar novos intervalos em y
        labels = paste0(as.character(abs(seq(-5, 5, .5)))))

# trocar as cores das barras
p <- p +  scale_fill_manual(values = c("#009E73", "#0072B2"), 
                     name = "")

# adicionar os percentuais no gráfico na forma de texto
p <- p +geom_text(aes(label = paste0(round(abs(perc),1), "%"), y = perc2 ), size = 3,
            color = "black", fontface = "bold")

# retirar as descrições de x e y
p <- p + labs(x = "", y = "")

# modificar o tema
p <- p + theme_bw()


########################### 
# o mesmo em um só código #
###########################
p <- ggplot(data = t, aes(x = fx_idade, y = perc , fill = V2007))+
  
  geom_bar(data = subset(t, V2007 == "Homem"), stat = "identity") +  
  
  geom_bar(data = subset(t, V2007 == "Mulher"), stat = "identity") +
  
    scale_y_continuous(breaks = seq(-5, 5, .5), 
                       labels = paste0(as.character(abs(seq(-5, 5, .5))))) +
  
    coord_flip() +
    scale_fill_manual(values = c("#009E73", "#0072B2"), 
                      labels = c("Homem", "Mulher"), name = "") +
    theme_classic() +
    geom_text(aes(label = paste0(round(abs(perc),1), "%"), y = perc2 ), size = 3,
              color = "black", fontface = "bold") +
    labs(x = "", y = "")
  





