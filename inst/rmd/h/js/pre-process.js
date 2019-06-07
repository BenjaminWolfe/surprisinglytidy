// This code runs *before* remark.js generates the HTML slides from source.
// First get the `source` contents, what remark.js uses to generate the slides.
var source_content = document
  .getElementById("source")
  .textContent
  .split("\n");

// Run *backwards* through the remark.js source looking for ```{.class .class}
// or ![image-caption](/path/to/image..class1.class2..extension), in either case
// pulling out the classes, and re-injecting them in remark-compatible syntax.
// We run through it *backwards* so that we can replace as we go.
const classes_pattern = /```\{(.*)\}/;
const class_pattern = /\.[a-zA-Z][\w-]*/g;
const false_class_pattern = /\w+\.\w+/g;
const image_pattern = /!\[.*\]\(.*\.\.([\w\-\.]+)\.\.[\w]+\)/;

for (let i = source_content.length - 1; i >= 0; i--) {

  // First watch for Pandoc classes.
  if (source_content[i].substring(0, 4) == "```{") {

    // Now run *forwards* to find the end of the block (```).
    let j;
    for (j = i + 1; j < source_content.length; j++) {
      if (source_content[j].substring(0, 3) == "```") {
        break;
      }
    }

    // Get all classes. Note workarounds for edge cases (see examples below).
    // The xaringan tutorial has ```{r tidy=FALSE}: no dots, no classes; ignore.
    // The tutorial also has highlight.output = TRUE: dot, but not a real class!
    let classes = source_content[i]
      .match(classes_pattern)[1]
      .replace(false_class_pattern, "")
      .match(class_pattern);
    if (classes === null) continue;

    // If this is an R code block, that's not a real class.
    // It is, however, important to add to the top fence for code highlighting.
    let top_fence = classes.includes(".r") ? "```r" : "```";
    classes = classes.filter(cls => cls !== ".r");

    // The final replacement should be .class[.class[,
    // then the fenced code block, then as many closing brackets as needed.
    for (let k = 0; k < classes.length; k++) {
      classes[k] = classes[k] + "[";
    }
    let replacement = [classes.join("")]
      .concat(top_fence)
      .concat(source_content.slice(i + 1, j + 1))
      .concat("]".repeat(classes.length));

    // Splice that into the code.
    // I would use `splice` but I'm not clear on the syntax here.
    source_content = source_content
      .slice(0, i)
      .concat(replacement)
      .concat(source_content.slice(j + 1, source_content.length));
  }

  // Now watch for classes inserted into image filenames.
  if (image_pattern.test(source_content[i])) {
    let classes = source_content[i]
      .match(image_pattern)[1]
      .split(".");

    // The final replacement should be .class[.class[,
    // then the fenced code block, then as many closing brackets as needed.
    for (let k = 0; k < classes.length; k++) {
      classes[k] = "." + classes[k] + "[";
    }
    let replacement = [classes.join("")]
      .concat(source_content[i])
      .concat("]".repeat(classes.length));

    // Splice that into the code.
    // I would use `splice` but I'm not clear on the syntax here.
    source_content = source_content
      .slice(0, i)
      .concat(replacement)
      .concat(source_content.slice(i + 1, source_content.length));
  }
}

// Now concatenate the array back into a string, and replace the source text.
document
  .getElementById("source")
  .textContent = source_content.join("\n");
