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
      <table className="metrics-table">
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
      cols.push(<td key={i}>{td}</td>);
    });
    return (<tr>{cols}</tr>);
  }
});
