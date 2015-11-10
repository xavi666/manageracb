from sklearn import preprocessing

# function declarations

def classify(clf, train, test, marge):
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
	print predictions

	encerts = float(sum(map(lambda x, y: (int(x) - int(y)) * (-1) <= marge, predictions, testY)))
	#encerts = float(sum(map(lambda x, y: int(x) == int(y), predictions, testY)))

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