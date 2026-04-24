Judge.delete_all
QuestionSort.delete_all
Option.delete_all
Question.delete_all

questions_data = [
  {
    content: "日本の現在の首都はどこですか？",
    options: [
      { content: "京都", is_answer: false },
      { content: "東京", is_answer: true },
      { content: "大阪", is_answer: false },
      { content: "福岡", is_answer: false }
    ]
  },
  {
    content: "太陽系で最も大きな惑星はどれですか？",
    options: [
      { content: "火星", is_answer: false },
      { content: "土星", is_answer: false },
      { content: "木星", is_answer: true },
      { content: "天王星", is_answer: false }
    ]
  },
  {
    content: "「吾輩は猫である」の著者は誰ですか？",
    options: [
      { content: "芥川龍之介", is_answer: false },
      { content: "夏目漱石", is_answer: true },
      { content: "太宰治", is_answer: false },
      { content: "三島由紀夫", is_answer: false }
    ]
  },
  {
    content: "水（H2O）の沸点は標準気圧下で何度ですか？",
    options: [
      { content: "90度", is_answer: false },
      { content: "100度", is_answer: true },
      { content: "110度", is_answer: false },
      { content: "120度", is_answer: false }
    ]
  },
  {
    content: "世界で最も高い山はどれですか？",
    options: [
      { content: "K2", is_answer: false },
      { content: "富士山", is_answer: false },
      { content: "エベレスト", is_answer: true },
      { content: "モンブラン", is_answer: false }
    ]
  },
  {
    content: "ダイヤモンドの構成元素は何ですか？",
    options: [
      { content: "酸素", is_answer: false },
      { content: "炭素", is_answer: true },
      { content: "窒素", is_answer: false },
      { content: "水素", is_answer: false }
    ]
  },
  {
    content: "世界で最も面積が広い国はどこですか？",
    options: [
      { content: "アメリカ", is_answer: false },
      { content: "中国", is_answer: false },
      { content: "ロシア", is_answer: true },
      { content: "カナダ", is_answer: false }
    ]
  },
  {
    content: "三角形の内角の和は何度ですか？",
    options: [
      { content: "90度", is_answer: false },
      { content: "180度", is_answer: true },
      { content: "270度", is_answer: false },
      { content: "360度", is_answer: false }
    ]
  },
  {
    content: "将棋の駒で、成ると「金」と同じ動きになるものは次のうちどれ？",
    options: [
      { content: "角行", is_answer: false },
      { content: "飛車", is_answer: false },
      { content: "銀将", is_answer: true },
      { content: "王将", is_answer: false }
    ]
  },
  {
    content: "1年は何秒ですか（およそ）？",
    options: [
      { content: "約300万秒", is_answer: false },
      { content: "約3000万秒", is_answer: true },
      { content: "約3億秒", is_answer: false },
      { content: "約30億秒", is_answer: false }
    ]
  }
]

questions_data.each do |q_data|
  question = Question.create!(content: q_data[:content])
  q_data[:options].each do |o_data|
    question.options.create!(o_data)
  end
end

puts "Questions and Options created."

# 回答データの作成
puts "Creating judge data..."
user_id = "user_seed_001"

Question.all.each_with_index do |question, index|
  sort_record = QuestionSort.create!(
    question: question,
    sort: index + 1,
    user_id: user_id
  )

  is_correct = index.even?
  
  if is_correct
    correct_option = question.options.find_by(is_answer: true)
    Judge.create!(
      question_sort: sort_record,
      choice: correct_option.content,
      is_answer: true
    )
  else
    wrong_option = question.options.find_by(is_answer: false)
    Judge.create!(
      question_sort: sort_record,
      choice: wrong_option.content,
      is_answer: false
    )
  end
end

puts "Seed completed!"
puts "Created #{Question.count} questions, #{Option.count} options, #{QuestionSort.count} sorts, and #{Judge.count} judges."
