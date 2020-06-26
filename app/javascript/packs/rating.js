const { useDebugValue } = require("react");

class RatingsUpdater
{
  constructor(options)
  {
    this.$main = options.main;
    this.$form = options.form;
    this.product_id = options.product_id;
  }

  init()
  {
    this.$form.each((_i,element) => element.addEventListener('click',(event) => {
      this.magic(element.previousElementSibling.value,  element.form.action);
      event.preventDefault();
    } ))
  }

  magic(rating, productUrl)
  {
    $.ajax({
      url: productUrl,
      type: "get",
      data: $.param({ product_rating: rating }), 
      success: (data) => {
        Array.from(this.$main).forEach((element) => {
          if (element.getAttribute(this.product_id) == data.product_id){
            element.innerHTML = `(${data.rating}/5)` }
        })
      }
    })
  }
}

$(document).on('turbolinks:load', function() {
  let options = {
    main: $('.rating_value'),
    form: $('.ratings input[type=submit]'),
    product_id: 'data-product-id'
  }

  let updater = new RatingsUpdater(options);
  updater.init();
});