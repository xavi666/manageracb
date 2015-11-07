from sklearn import preprocessing

# function declarations

def classify2(clf, train, test):
	trainXY = list(map(lambda l: list(map(int, l[0:3])), train))
	
	trainX = list(map(lambda l: list(map(int, l[0:3])), train))
	trainY_chanel = list(map(lambda l: l[4], train))
	trainY_region = list(map(lambda l: l[4], train))

	testX_chanel = list(map(lambda l: list(map(int, l[0:3])), test))
	testY_chanel = list(map(lambda l: l[4], test))	
	testY_region = list(map(lambda l: l[4], test))	


	scaler = preprocessing.StandardScaler().fit(trainX)
	trainX = scaler.transform(trainX)
	testX_chanel = scaler.transform(testX_chanel)

	clf.fit(trainX, trainY_chanel)
	predictions = clf.predict(testX_chanel)

	correctesC = []
	for tY, p, trXY in zip(testY_chanel, predictions, trainXY):
		if tY == p: 
			correctesC.append(trXY)

	testX_chanel_region = list(map(lambda l: list(map(int, l[2:7])), correctesC))
	clf.fit(trainX, trainY_region)
	predictions = clf.predict(testX_chanel_region)

	correctesCR = []
	for tY, p, trXY in zip(testY_region, predictions, trainXY):
		if tY == p: 
			correctesCR.append(trXY)

	return len(correctesCR) / len(test) * 100

def sets_svm_prec2(clf, l):
	# training set: 2 of each 3
	train = list(map(lambda x: x[1],
		filter(lambda v: v[0] % 3 != 0, enumerate(l))))

	# test set: 1 of each 3
	test = list(map(lambda x: x[1],
		filter(lambda v: v[0] % 3 == 0, enumerate(l))))

	# application of svm
	return classify2(clf, train, test)