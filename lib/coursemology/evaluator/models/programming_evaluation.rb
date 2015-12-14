class Coursemology::Evaluator::Models::ProgrammingEvaluation < Coursemology::Evaluator::Models::Base
  get :find, 'courses/assessment/programming_evaluations/:id'
  post :allocate, 'courses/assessment/programming_evaluations/allocate'
end
