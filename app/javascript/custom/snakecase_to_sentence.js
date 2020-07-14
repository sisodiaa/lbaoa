String.prototype.snakecase_to_sentence = function() {
  return this.replace(/(_)/g, " ");
};
