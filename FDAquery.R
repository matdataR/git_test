library(httr)
library(jsonlite)
library(tidytext)
library(tidyverse)
test <- httr::GET("https://api.fda.gov/device/event.json?search=device.generic_name:pfo&limit=5")

test <- httr::GET("https://api.fda.gov/device/event.json?search=device.device_report_product_code:MLV+AND+date_received:[2017-01-01+TO+2019-09-01]&limit=100")



cont <- content(test, "text")

cont_txt <- fromJSON(cont)


aes <- cont_txt$results


mdr_text <- aes$mdr_text


txt <- lapply(mdr_text, function(x) x[["text"]]) %>%
  unlist() %>%
  as.tibble()%>%
  mutate(num = 1:length(value)) %>%
  select(num, value)


# n = 1
txt_tokens <- txt %>% tidytext::unnest_tokens(word, value) %>%
  anti_join(stop_words)

tf_idf <- txt %>% tidytext::unnest_tokens(word, value) %>%
  anti_join(stop_words) %>%
  count(num, word) %>%
  bind_tf_idf(word, num, n)


txt_tokens %>% count(word) %>% arrange(desc(n)) %>%
  filter(n > 20)%>%
  ggplot(aes(x = reorder(word,n), y = n)) +
  geom_bar(stat = "identity")+
  coord_flip()

# n = 2
txt_tokens <- txt %>% tidytext::unnest_tokens(ngram, value, token = "ngrams", n = 2) %>%
  separate(col = ngram, into = c("word1", "word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  unite(ngram, word1, word2, sep = " ")

txt_tokens %>% count(ngram) %>% arrange(desc(n)) %>%
  filter(n > 5, n <10)%>%
  ggplot(aes(x = reorder(ngram,n), y = n)) +
  geom_bar(stat = "identity")+
  coord_flip()


# n = 3
txt_tokens <- txt %>% tidytext::unnest_tokens(ngram, value, token = "ngrams", n = 3) %>%
  separate(col = ngram, into = c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word3 %in% stop_words$word) %>%
  unite(ngram, word1, word2, word3, sep = " ")
  
txt_tokens %>% count(ngram) %>% arrange(desc(n)) %>%
  filter(n > 2,n <6)%>%
  ggplot(aes(x = reorder(ngram,n), y = n)) +
  geom_bar(stat = "identity")+
  coord_flip()



# n = 4
txt_tokens <- txt %>% tidytext::unnest_tokens(ngram, value, token = "ngrams", n = 4) %>%
  separate(col = ngram, into = c("word1", "word2", "word3", "word4"), sep = " ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word3 %in% stop_words$word) %>%
  filter(!word4 %in% stop_words$word) %>%
  unite(ngram, word1, word2, word3, word4, sep = " ")

txt_tokens %>% count(ngram) %>% arrange(desc(n)) %>%
  filter(n > 5, n <11)%>%
  ggplot(aes(x = reorder(ngram,n), y = n)) +
  geom_bar(stat = "identity")+
  coord_flip()


# n = 5
txt_tokens <- txt %>% tidytext::unnest_tokens(ngram, value, token = "ngrams", n = 5) %>%
  separate(col = ngram, into = c("word1", "word2", "word3", "word4", "word5"), sep = " ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word3 %in% stop_words$word) %>%
  filter(!word4 %in% stop_words$word) %>%
  filter(!word5 %in% stop_words$word) %>%
  unite(ngram, word1, word2, word3, word4, word5, sep = " ")

txt_tokens %>% count(ngram) %>% arrange(desc(n)) %>%
  filter(n > 2, n <6)%>%
  ggplot(aes(x = reorder(ngram,n), y = n)) +
  geom_bar(stat = "identity")+
  coord_flip()
