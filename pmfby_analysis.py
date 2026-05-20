#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np


# In[2]:


df=pd.read_csv(r"C:\Users\khushi\Downloads\PMFBY Project\PMFBY coverage.csv")


# In[3]:


df.shape


# In[4]:


df.head()


# In[5]:


df.columns=df.columns.str.strip()


# In[6]:


df=df.rename(columns={
   'sssyName.year': 'year',
    'sssyName.seasonName': 'season',
    'sssyName.schemeName': 'scheme',
    'sssyName.stateName': 'state',
    'level3Name': 'district',
    'cropName': 'crop',
    'sumInsured': 'sum_insured',
    'premiumRate': 'premium_rate',
    'stateShare': 'state_share_pct',
    'goiShare': 'goi_share_pct',
    'categoryName': 'crop_category',
    'cropType': 'crop_type',
    'unit': 'unit',
    'indemnityLevel': 'indemnity_level',
    'farmerShare': 'farmer_share_pct',
    'farmerShareValue': 'farmer_share_value',
    'goiShareValue': 'goi_share_value',
    'stateShareValue': 'state_share_value',
    'insuranceCompanyName': 'insurance_company'
})


# In[7]:


df.head()


# In[8]:


important_cols = [
    'year',
    'season',
    'scheme',
    'state',
    'district',
    'crop',
    'crop_category',
    'crop_type',
    'unit',
    'sum_insured',
    'premium_rate',
    'farmer_share_pct',
    'state_share_pct',
    'goi_share_pct',
    'farmer_share_value',
    'state_share_value',
    'goi_share_value',
    'indemnity_level',
    'insurance_company'
]


# In[9]:


df_clean=df[important_cols].copy()


# In[10]:


df_clean.shape


# In[11]:


pmfby_clean=df_clean[df_clean['scheme']=='Pradhan Mantri Fasal Bima Yojana'].copy()


# In[12]:


pmfby_clean.shape


# In[13]:


pmfby_clean['scheme'].unique()


# In[14]:


pmfby_clean.drop(columns=['scheme'],inplace=True)


# In[15]:


pmfby_clean.shape


# In[16]:


pmfby_clean.info()


# In[17]:


pmfby_clean.isnull().sum().sort_values(ascending=False)


# In[18]:


pmfby_clean.duplicated().sum()


# In[19]:


pmfby_clean.describe()


# In[20]:


pmfby_clean['total_subsidy'] = (
    pmfby_clean['state_share_value']
    +
    pmfby_clean['goi_share_value']
)


# In[21]:


pmfby_clean.shape


# In[22]:


pmfby_clean['total_premium']=(pmfby_clean['farmer_share_value']
+pmfby_clean['state_share_value']
+pmfby_clean['goi_share_value'])


# In[23]:


pmfby_clean.shape


# In[24]:


pmfby_clean['gov_subsidy_pct']=(pmfby_clean['total_subsidy']
                                /pmfby_clean['total_premium'])*100


# In[25]:


pmfby_clean.shape


# In[26]:


pmfby_clean['premium_to_insured_pct'] = (
    pmfby_clean['total_premium']
    /
    pmfby_clean['sum_insured']
) * 100


# In[27]:


pmfby_clean.shape


# In[28]:


pmfby_clean.to_csv(
    "pmfby_final_analytical_dataset.csv",
    index=False
)


# In[29]:


print(pmfby_clean.columns.tolist())


# In[30]:


pmfby_clean = pmfby_clean.loc[:, ~pmfby_clean.columns.duplicated()]


# In[31]:


print(pmfby_clean.columns.tolist())


# In[32]:


pmfby_clean.shape


# In[33]:


pmfby_clean.to_csv(
    r"C:\Users\khushi\Downloads\PMFBY Project\pmfby_sql_final.csv",
    index=False
)


# In[ ]:




