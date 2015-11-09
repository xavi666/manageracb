from random import shuffle
import numpy as np 
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn import tree
from sklearn import svm
from exercici1 import * 
from time import time

# warning filter
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)
warnings.filterwarnings("ignore", category=UserWarning)

# obrim fitxer
l = list(map(lambda l: (l.strip()).split(','),
	open('export.csv', 'r').readlines()))

# eliminem la primera fila, que conte les capcaleres
l.pop(0)

#print(l)
# desordenem
#shuffle(l)

# PRECISION
print('----------------------')
print('NAIVE BAYES')
# classification
clf = GaussianNB()
t1 = time()
acc = sets_svm_prec(clf, l)
print('Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

print('----------------------')
print('kNN')
# classification
for i in range(0, 12):
	n_neighbors = i * i
	if n_neighbors % 2 != 0:
		clf = KNeighborsClassifier(n_neighbors=n_neighbors)
		t1 = time()
		acc = sets_svm_prec(clf, l)
		print('n_neighbors = ', n_neighbors, ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

print('----------------------')
