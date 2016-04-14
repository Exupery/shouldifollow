var MetricsTable = React.createClass({
  propTypes: {
    headings: React.PropTypes.array,
    rows: React.PropTypes.array
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
    this.props.tds.forEach(function(td, i) {
      cols.push(<TableCell td={td} index={i} key={i} />);
    });
    return (<tr>{cols}</tr>);
  }
});

var TableCell = React.createClass({
  propTypes: {
    td: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ]),
    index: React.PropTypes.number
  },

  render: function() {
    function getHtml(td) {
        return {__html: formatNum(td)};
    };
    var clazz = (this.props.index == 0) ? "left" : "metric";
    return (<td className={clazz} key={this.props.index} dangerouslySetInnerHTML={getHtml(this.props.td)}></td>);
  }
});

function formatNum(num) {
  return (Number.isInteger(num) && num > 999999) ? (num / 1000000).toFixed(2) + "M" : num;
}
