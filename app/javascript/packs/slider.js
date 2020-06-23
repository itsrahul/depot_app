class SlideShow
{
  constructor(details)
  {
    this.$main = details.displayElement;
    this.$item = details.slideshowElement;
    this.displayClass = details.className;
    this.$displayed = null;
    this.toBeDisplayed = null;
  }

  startSlideshow()
  {
    this.$main.prepend(this.$item);
    this.$item.children()
      .hide()
      .first().show().addClass(this.displayClass);
    this.runSlideshow();
  }

  runSlideshow()
  {
    this.$displayed = this.$item.find("div." + this.displayClass);

    if(this.$displayed.next()[0] == null)
    {
      this.toBeDisplayed = this.$displayed.parent().children().first();
    }
    else
    {
      this.toBeDisplayed = this.$displayed.next();
    }

    this.$displayed
      .removeClass(this.displayClass)
      .fadeOut(1000)
      .promise()
      .done(() => {
        $(this.toBeDisplayed)
          .addClass(this.displayClass)
          .fadeIn(1000)
          .delay(1500)
          .promise()
          .done( this.runSlideshow());
      });
  }
}

$(document).on('turbolinks:load', function() {
  let details = {
    displayElement: $("div#slider"),
    slideshowElement: $("div#slideshow"),
    className: "onDisplay",
  }
  let slideshowList = new SlideShow(details);
  slideshowList.startSlideshow();
});