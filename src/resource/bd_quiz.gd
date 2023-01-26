extends Resource
class_name BDQuiz

export(Array, Resource) var bd

const quiz_answers = 30

func main():
	randomize()
	self.bd.shuffle()
	var test = self.bd.slice(0, quiz_answers-1)
	return test
