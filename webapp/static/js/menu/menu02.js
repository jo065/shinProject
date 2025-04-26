let g_menu02 = {};

$(document).ready(function () {
	tableInit();
	
});

//Define some test data
var cheeseData = [
    {id:1, type:"Brie", rind:"mould", age:"4 weeks", color:"white", image:"brie.jpg"},
    {id:2, type:"Cheddar", rind:"none", age:"1 year", color:"yellow", image:"cheddar.jpg"},
    {id:3, type:"Gouda", rind:"wax", age:"6 months", color:"cream", image:"gouda.jpg"},
    {id:4, type:"Swiss", rind:"none", age:"9 months", color:"yellow", image:"swiss.jpg"},
]
function tableInit() {
var table = new Tabulator("#menu02-table", {
    height:"600px",
    layout:"fitColumns",
    columnDefaults:{
      resizable:true,
    },
    data:cheeseData,
    columns:[
        {title:"Cheese", field:"type", sorter:"string"},
    ],
    rowFormatter:function(row){
        var element = row.getElement(),
        data = row.getData(),
        width = element.offsetWidth,
        rowTable, cellContents;

        //clear current row data
        while(element.firstChild) element.removeChild(element.firstChild);

        //define a table layout structure and set width of row
        rowTable = document.createElement("table")
        rowTable.style.width = (width - 18) + "px";

        rowTabletr = document.createElement("tr");

        //add image on left of row
        cellContents = "<td><img src='/sample_data/row_formatter/" + data.image + "'></td>";

        //add row data on right hand side
        cellContents += "<td><div><strong>Type:</strong> " + data.type + "</div><div><strong>Age:</strong> " + data.age + "</div><div><strong>Rind:</strong> " + data.rind + "</div><div><strong>Colour:</strong> " + data.color + "</div></td>"

        rowTabletr.innerHTML = cellContents;

        rowTable.appendChild(rowTabletr);

        //append newly formatted contents to the row
        element.append(rowTable);
    },
});
}

function sampleAPI() {
    $.ajax({
        url: './sample',
        method: "GET",
		data:{
			test:'sample'
		},
        dataType: "json",
        success: function (res) {
            console.log("📦 sampleAPI response:", res);
        },
        error: function (err) {
            console.error("❌ sampleAPI 호출 실패:", err);
        }
    });
}

function swalTest(){
	Swal.fire('Swal 함수가 올바르게 작동함.');
}