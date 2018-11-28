function grab_stds(...indexes) {
    const rows = document.querySelectorAll('.din_spec_table tr:not(:first-child)');
    const result = [];
    rows.forEach((row) => {
        const tds = row.querySelectorAll('td');
        const res = [];
        indexes.forEach((idx) => {
            res.push( parseFloat(tds[idx].innerText.replace(/m/gi, ''), 10) );
        });
        result.push(res);
    });
    console.log(JSON.stringify(result));
}
