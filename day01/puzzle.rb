left, right = ARGF
  .readlines
  .map { _1.split.map(&:to_i) }
  .transpose
  .map(&:sort)

p(left.zip(right).sum { (_1 - _2).abs }) # p1

p(left.sum { _1 * right.count(_1) })     # p2

