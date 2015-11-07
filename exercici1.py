from sklearn import preprocessing

# function declarations

def classify(clf, train, test):
	trainX = list(map(lambda l: list(map(int, l[0:3])), train))
	testX = list(map(lambda l: list(map(int, l[0:3])), test))
	trainY = list(map(lambda l: l[4], train))
	testY = list(map(lambda l: l[4], test))	

	# Estandaritzacio
	scaler = preprocessing.StandardScaler().fit(trainX)
	trainX = scaler.transform(trainX)
	testX = scaler.transform(testX)

	clf.fit(trainX, trainY)

	predictions = clf.predict(testX)
	return sum(map(lambda x, y: x == y, predictions, testY)) / len(testX) * 100

def sets_svm_prec(clf, l):
	# training set: 2 of each 3
	train = list(map(lambda x: x[1],
		filter(lambda v: v[0] % 3 != 0, enumerate(l))))

	# test set: 1 of each 3
	test = list(map(lambda x: x[1],
		filter(lambda v: v[0] % 3 == 0, enumerate(l))))

	# application of svm
	return classify(clf, train, test)