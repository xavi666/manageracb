from __future__ import division
from random import shuffle
import numpy as np 
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn import tree
from sklearn import svm
from sklearn.svm import SVR
from exercici1 import * 
from time import time
#import matplotlib.pyplot as plt

# source venv/bin/activate
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
shuffle(l)

# marge
marge = 1

# PRECISION
print('----------------------')
#print('NAIVE BAYES')
# classification
#clf = GaussianNB()
#t1 = time()
#acc = sets_svm_prec(clf, l, marge)
#print('Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

print('----------------------')
#print('kNN')
# classification
#for i in range(0, 12):
#	n_neighbors = i * i
#	if n_neighbors % 2 != 0:
#		clf = KNeighborsClassifier(n_neighbors=n_neighbors)
#		t1 = time()
#		acc = sets_svm_prec(clf, l, marge)
#		print('n_neighbors = ', n_neighbors, ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

print('----------------------')

#print('DECISION TREES')
# classification
#clf = tree.DecisionTreeClassifier()
#t1 = time()
#acc = sets_svm_prec(clf, l, marge)
#print('Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

#print('----------------------')
#print('SVM')

# classification
#clf = svm.SVC(kernel='linear')
#t1 = time()
#acc = sets_svm_prec(clf, l, marge)
#print('Kernel=linear - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

# classification
#clf = svm.SVC(kernel='poly', degree=1)
#t1 = time()
#acc = sets_svm_prec(clf, l, marge)
#print('Kernel=poly, degree=2 - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

# classification
#for i in range(0, 4):
  #gamma = i * 50
  #clf = svm.SVC(kernel='rbf', gamma=gamma)
  #t1 = time()
  #acc = sets_svm_prec(clf, l, marge)
  #print('Kernel=rbf, gamma=', gamma, ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
 
# SVR
# RBF
svr_rbf = SVR(C=1e3, gamma=0.1, cache_size=200, coef0=0.0, degree=3, epsilon=0.1,
    kernel='rbf', max_iter=-1, shrinking=True, tol=0.001, verbose=False)
t1 = time()
acc = sets_svm_prec(svr_rbf, l, marge)
print('SVR rbf', ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
#y_rbf = svr_rbf.fit(X, y).predict(X)

# LIN
#svr_lin = SVR(kernel='linear', C=1e3)
#t1 = time()
#acc = sets_svm_prec(svr_lin, l, marge)
#print('SVR lin', ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
#y_lin = svr_lin.fit(X, y).predict(X)

# POLY
#svr_poly = SVR(kernel='poly', C=1e3, degree=2)
#t1 = time()
#acc = sets_svm_prec(svr_poly, l, marge)
#print('SVR poly', ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
#y_poly = svr_poly.fit(X, y).predict(X)


# classification
#for i in range(1, 5):
  #c = i * 50
  #clf = svm.SVC(kernel='linear', C=c)
  #t1 = time()
  #acc = sets_svm_prec(clf, l, marge)
  #print('Kernel=linear, C=', c, ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')