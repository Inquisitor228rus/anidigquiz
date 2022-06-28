extends Resource
class_name QuizQuestion

enum QuestionType { VIDEO }

export(String) var question_info
export(QuestionType) var type
export(VideoStream) var question_video
export (Array, String) var options
export(String) var correct
