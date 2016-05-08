var MetricsTable = React.createClass({
  propTypes: {
    headings: React.PropTypes.array,
    rows: React.PropTypes.array
  },
  componentDidMount: function() {
    adjustFontSize();
  },

  render: function() {
    var tableHeadings = [];
    this.props.headings.forEach(function(heading) {
      tableHeadings.push(<th key={heading}>{heading}</th>);
    });

    var tableRows = [];
    this.props.rows.forEach(function(row) {
      tableRows.push(<TableRow tds={row} key={row[0]} />);
    });

    return (
      <table className="metrics-table table table-hover auto-lr-margin minor-shadow">
        <thead>
          <tr className="heading-row">{tableHeadings}</tr>
        </thead>
        <tbody>
          {tableRows}
        </tbody>
      </table>
    );
  }
});

var TableRow = React.createClass({
  propTypes: {
    tds: React.PropTypes.array
  },

  render: function() {
    var cols = [];
    this.props.tds.forEach(function(td, i, tds) {
      var value = (i > 0 && tds[0].indexOf("per day") != -1) ? td.toFixed(1) : td;
      if (i > 0 && tds[0].indexOf("most used hashtag") != -1) {
        value = (value) ? <HashtagLink hashtag={td} /> : "-";
      }
      cols.push(<TableCell td={value} index={i} key={i} />);
    });
    return <tr>{cols}</tr>;
  }
});

var TableCell = React.createClass({
  propTypes: {
    td: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number,
      React.PropTypes.element,
    ]),
    index: React.PropTypes.number
  },

  render: function() {
    var clazz = (this.props.index == 0) ? "left" : "metric";
    return (<td className={clazz} key={this.props.index}>{formatNum(this.props.td)}</td>);
  }
});

var HashtagLink = React.createClass({
  propTypes: {
    hashtag: React.PropTypes.string
  },

  render: function() {
    var hashtag = this.props.hashtag;
    var url = "https://twitter.com/hashtag/"+hashtag+"?src=hash";
    var linkText = (hashtag.length > 18) ? hashtag.substring(0, 15) + "..." : hashtag;

    return <a href={url} target="_blank" className="metric-link hashtag-font auto-size" title={hashtag}>#{linkText}</a>;
  }
});

function formatNum(num) {
  return (Number.isInteger(num) && num > 999999) ? (num / 1000000).toFixed(2) + "M" : num;
}

function adjustFontSize() {
  var fontSize = parseInt($(".auto-size").css("font-size"));
  while ($(".metrics-table").width() > $("#stats").width() && fontSize > 10) {
    $(".auto-size").css("font-size", --fontSize + "px");
  }
}
