#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[27]:


data = pd.read_csv(r"C:\Users\Faris PC\Desktop\Data Analytics\netflix_titles_nov_2019.csv", index_col = "show_id")


# In[22]:


data


# In[14]:


mask1 = data["director"].isnull()


# In[15]:


data[mask1]


# In[21]:


data.drop_duplicates()


# In[28]:


data["director"] = data["director"].fillna("-Not Listed-")


# In[29]:


data


# In[31]:


data["date_added"] = data["date_added"].fillna(method = "ffill")


# In[32]:


data.head(10)


# In[33]:


data["type"].astype("category")


# In[34]:


data.info()


# In[35]:


data["type"] = data["type"].astype("category")


# In[39]:


data.info()


# In[41]:


data["rating"].astype("category")


# In[42]:


data["rating"] = data["rating"].astype("category")


# In[43]:


data.info()


# In[44]:


data.head(10)


# In[48]:


data.dtypes


# In[49]:


import datetime as dt


# In[51]:


data["date_added"] = pd.to_datetime(data["date_added"])


# In[52]:


data.dtypes


# In[53]:


data.head(10)


# In[55]:


data.sort_values(by = "date_added", ascending = False)


# In[57]:


data["cast"] = data["cast"].fillna("-Not Listed-")


# In[59]:


data.head(10)


# In[67]:


data["cast"] = data["cast"].fillna("-Not Listed-")


# In[68]:


data.head(10)


# In[ ]:




