from random import shuffle
import numpy as np 
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn import tree
from sklearn import svm
from exercici1 import * 
from exercici2 import * 
from time import time

# warning filter
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)
warnings.filterwarnings("ignore", category=UserWarning)

# obrim fitxer
l = list(map(lambda l: (l.strip()).split(','),
	open('statistics.csv', 'r').readlines()))

# eliminem la primera fila, que conte les capcaleres
l.pop(0)

# desordenem
shuffle(l)

# convertim a array
a = np.array(l)

# creo una llista amb la conquetanacio de cab (row[0]) i la zona (row[1])
classe = []
for row in a:
    classe.append([int(str(row[0])+str(row[1]))])

# afegim una columna al final amb la combinacio de les dues classes
l = np.append(a, classe, axis=1)

# PRECISION
print('----------------------')
print('NAIVE BAYES')
# classification
clf = GaussianNB()
t1 = time()
acc = sets_svm_prec(clf, l)
print('Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
# classification
t1 = time()
acc = sets_svm_prec2(clf, l)
print('Prec. Exercici2: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

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
		# classification
		t1 = time()
		acc = sets_svm_prec2(clf, l)
		print('n_neighbors = ', n_neighbors, ' - Prec. Exercici2: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

print('----------------------')

print('DECISION TREES')
# classification
clf = tree.DecisionTreeClassifier()
t1 = time()
acc = sets_svm_prec(clf, l)
print('Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
# classification
t1 = time()
acc = sets_svm_prec2(clf, l)
print('Prec. Exercici2: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

print('----------------------')
print('SVM')

# classification
clf = svm.SVC(kernel='linear')
t1 = time()
acc = sets_svm_prec(clf, l)
print('Kernel=linear - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
# classification
acc = sets_svm_prec2(clf, l)
t1 = time()
print('Kernel=linear - Prec. Exercici2: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

# classification
clf = svm.SVC(kernel='poly', degree=1)
t1 = time()
acc = sets_svm_prec(clf, l)
print('Kernel=poly, degree=2 - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
# classification
t1 = time()
acc = sets_svm_prec2(clf, l)
print('Kernel=linear, degree=2 - Prec. Exercici2: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

# classification
for i in range(0, 4):
	gamma = i * 50
	clf = svm.SVC(kernel='rbf', gamma=gamma)
	t1 = time()
	acc = sets_svm_prec(clf, l)
	print('Kernel=rbf, gamma=', gamma, ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
	# classification
	t1 = time()
	acc = sets_svm_prec2(clf, l)
	print('Kernel=rbf, gamma=', gamma, ' - Prec. Exercici2: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')

# classification
for i in range(1, 5):
	c = i * 50
	clf = svm.SVC(kernel='linear', C=c)
	t1 = time()
	acc = sets_svm_prec(clf, l)
	print('Kernel=linear, C=', c, ' - Prec. Exercici1: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
	# classification
	t1 = time()
	acc = sets_svm_prec2(clf, l)
	print('Kernel=linear, C=', c, ' - Prec. Exercici2: ', '%.2f' % acc, ' en ', '%.6f' % (time()-t1), ' segundos.')
