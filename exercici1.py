from sklearn import preprocessing
from sklearn.metrics import mean_squared_error
#import matplotlib.pyplot as plt

# function declarations

def classify(clf, train, test, marge):
	trainX = list(map(lambda l: list(map(int, l[4:43])), train))
	testX = list(map(lambda l: list(map(int, l[4:43])), test))
	trainY = list(map(lambda l: list(map(l[44])), train))
	testY = list(map(lambda l: list(map(l[44])), test))	

	# 44 VALUE
	# 45 PUNTS 
	# 46 REBOTS
	# 47 ASSISTENCIES

	# Estandaritzacio
	scaler = preprocessing.StandardScaler().fit(trainX)	
	trainX = scaler.transform(trainX)
	testX = scaler.transform(testX)

	clf.fit(trainX, trainY)
	predictions = clf.predict(testX)
	print(testY)
	#print(predictions)
	mean_squared_error(testY, predictions)
	mean_squared_error(testY, predictions, multioutput='raw_values')
	mean_squared_error(testY, predictions, multioutput=[0.3, 0.7])

	encerts = float(sum(map(lambda x, y: (int(x) - int(y)) * (-1) <= marge, predictions, testY)))
	#encerts = float(sum(map(lambda x, y: int(x) == int(y), predictions, testY)))

	###############################################################################
	# look at the results
	#plt.scatter(testX, testY, c='k', label='data')
	#plt.hold('on')
	#plt.plot(X, y_rbf, c='g', label='RBF model')
	#plt.xlabel('data')
	#plt.ylabel('target')
	#plt.title('Support Vector Regression')
	#plt.legend()
	#plt.show()

	size = float(len(testX))
	return encerts / size * 100

def sets_svm_prec(clf, l, marge):
	# training set: 2 of each 3
	train = list(map(lambda x: x[1],
		filter(lambda v: v[0] % 3 != 0, enumerate(l))))

	# test set: 1 of each 3
	test = list(map(lambda x: x[1],
		filter(lambda v: v[0] % 3 == 0, enumerate(l))))

	# application of svm
	return classify(clf, train, test, marge)