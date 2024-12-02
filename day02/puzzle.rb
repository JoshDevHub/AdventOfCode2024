Report = Data.define(:levels) do
  def safe?
    (increasing? || decreasing?) && correct_adj_diffs?
  end

  def pairwise_all? = levels.each_cons(2).all? { yield _1, _2 }

  def correct_adj_diffs? = pairwise_all? { (_1 - _2).abs.between?(1, 3) }

  def decreasing? = pairwise_all? { _1 > _2 }

  def increasing? = pairwise_all? { _2 > _1 }

  def safe_with_variants? = safe? || report_variants.any?(&:safe?)

  def report_variants
    (0...levels.length).map { Report.new(levels[..._1] + levels[(_1 + 1)..]) }
  end
end

reports = ARGF
  .readlines
  .map { Report.new(_1.split.map(&:to_i)) }

p reports.count(&:safe?)               # p1

p reports.count(&:safe_with_variants?) # p2
