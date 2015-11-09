from random import shuffle
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from time import clock
from copy import deepcopy

# warning filter
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 


# function declarations
def str2int(l):
    return list(map(int, l))

def ex1(clf, trainX, testX, trainY, testY, text):
    t0 = clock()
    error = 1 - clf.fit(trainX, trainY).score(testX, testY)
    print(text, round(error, 2), round(clock() - t0,3))

def ex2(clfp, trainX, testX, trainY, testY, text):
    # train
    t0 = clock()
    clf = {}
    Y = list(map(lambda l: l[0], trainY))
    clf[0] = deepcopy(clfp)
    clf[0].fit(trainX, Y)
    for classe in [1,2]:
        f = list(filter(lambda l: l[1][0]==classe, zip(trainX, trainY)))
        X2 = list(map(lambda l: l[0], f))
        Y2 = list(map(lambda l: l[1][1], f))
        clf[classe] = deepcopy(clfp)
        clf[classe].fit(X2, Y2)
    # test
    er, tl = 0, 0
    for exX, exY in zip(testX, testY):
        pred = clf[0].predict([exX])[0]
        pred2 = clf[pred].predict([exX])[0]
        tl = tl + 1
        if exY != [pred, pred2]:
            er = er + 1
    # results
    print(text, round(er/tl, 2), round(clock() - t0,3))

# open file
l = list(map(lambda l: (l.strip()).split(','),
             open('Wholesale customers.csv', 'r').readlines()))
l.pop(0)
# examples shuffle
shuffle(l)

# splitting files
trainX = list(map(lambda l: str2int(l[2:]), l[:300]))
testX = list(map(lambda l: str2int(l[2:]), l[300:]))
trainY = list(map(lambda l: str2int(l[:2]), l[:300]))
testY = list(map(lambda l: str2int(l[:2]), l[300:]))

### ex 1 ###
print('## ex1: error time ##')
Yr = list(map(lambda l: l[0]*10+l[1], trainY))
Ys = list(map(lambda l: l[0]*10+l[1], testY))

ex1(GaussianNB(), trainX, testX, Yr, Ys, 'gnb:')
ex1(DecisionTreeClassifier(), trainX, testX, Yr, Ys, 'dts:')
ex1(KNeighborsClassifier(n_neighbors=3), trainX, testX, Yr, Ys, 'knn:')

#ex1(SVC(kernel='linear'), trainX, testX, Yr, Ys, 'svm(linear):')
#ex1(SVC(kernel='poly',degree=2), trainX, testX, Yr, Ys, 'svm(poly2):')
ex1(SVC(kernel='rbf',gamma=0.1), trainX, testX, Yr, Ys, 'svm(rbf):')

### ex 2 ###
print('## ex2: error time ##')
ex2(GaussianNB(), trainX, testX, trainY, testY, 'gnb:')
ex2(DecisionTreeClassifier(), trainX, testX, trainY, testY, 'dts:')
ex2(KNeighborsClassifier(n_neighbors=3), trainX, testX, trainY, testY, 'knn:')

#ex2(SVC(kernel='linear'), trainX, testX, trainY, testY, 'svm(linear):')
#ex2(SVC(kernel='poly',degree=2), trainX, testX, trainY, testY, 'svm(poly2):')
ex2(SVC(kernel='rbf',gamma=0.1), trainX, testX, trainY, testY, 'svm(rbf):')
