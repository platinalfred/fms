<?php
/*
 * Script:    DataTables server-side script for PHP and MySQL
 * Copyright: Nov, 2016 - Allan Jes
 * Copyright: 2016 - Steven Lavoie
 * Copyright: 2012 - John Becker, Beckersoft, Inc.
 * Copyright: 2010 - Allan Jardine
 * License:   GPL v2 or BSD (3-point)
 * URL:   https://gist.github.com/sraboy/3102387f44248a80cb9e9e1fe851307d
 */
 
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class DataTable extends Db{
	
	public function get($table, $index_column, $columns, $where = "", $group_by = "") {
		// Paging
		$sLimit = "";
		if ( isset( $_POST['start'] ) && $_POST['length'] != '-1' ) {
			$sLimit = "LIMIT ".intval( $_POST['start'] ).", ".intval( $_POST['length'] );
		}
		
		// Ordering
		$sOrder = "";
		if ( isset( $_POST['order'][0]['column'] ) && $_POST['columns'][$_POST['order'][0]['column']]['orderable'] == "true" ) {
			$sOrder = "ORDER BY ".$columns[$_POST['order'][0]['column']]." ".$_POST['order'][0]['dir'];
		}
		// Grouping
		$sGroupBy = "";
		if ( $group_by != "" ) {
			$sGroupBy = "GROUP BY ".$group_by;
		}
		
		/* 
		 * Filtering
		 * NOTE this does not match the built-in DataTables filtering which does it
		 * word by word on any field. It's possible to do here, but concerned about efficiency
		 * on very large tables, and MySQL's regex functionality is very limited
		 */
		$sWhere = "";
		if( $where !== ""){
			$sWhere = "WHERE " . $where;
		}
		if ( isset($_POST['search']['value']) && $_POST['search']['value'] != "" ) {
			if ( $sWhere == "" ) {
				$sWhere = "WHERE (";
			}
			else {
				$sWhere .= " AND (";
			}
			for ( $i=0 ; $i<count($columns) ; $i++ ) {
				if ( isset($_POST['columns'][$i]['searchable']) && $_POST['columns'][$i]['searchable'] == "true" ) {
					$sWhere .= $columns[$i]." LIKE ? OR ";
				}
			}
			$sWhere = substr_replace( $sWhere, "", -3 ); //deletes the last OR
			$sWhere .= ')';
		}
		
		// Individual column filtering
		for ( $i=0 ; $i<count($columns) ; $i++ ) {
			if ( isset($_POST['columns'][$i]['searchable']) && $_POST['columns'][$i]['searchable'] == "true" && $_POST['columns'][$i]['search']['value'] != '' ) {
				if ( $sWhere == "" ) {
					$sWhere = "WHERE ";
				}
				else {
					$sWhere .= " AND ";
				}
				$sWhere .= $columns[$i]." LIKE ? ";
			}
		}
		
		// SQL queries get data to display
		$sQuery = "SELECT SQL_CALC_FOUND_ROWS ".
			str_replace(" , ", " ", implode(", ", $columns)).
			" FROM ".
			$table.
			" ".
			$sWhere.
			" ".
			$sGroupBy;
			" ".
			$sOrder.
			" ".
			$sLimit;
		//prepare the statement
		$preparedStatement = $this->prepareStatement($sQuery);
		if($preparedStatement){
			// Bind parameters
			$data_types = '';
			$a_params = $bind_params = array();
			if ( isset($_POST['search']['value']) && $_POST['search']['value'] != "" ) {
				for ( $i=0 ; $i<count($columns) ; $i++ ) {
					if ( isset($_POST['columns'][$i]['searchable']) && $_POST['columns'][$i]['searchable'] == "true" ) {
						$data_types .= 's';
						$bind_params[]= '%'.$_POST['search']['value'].'%';
					}
				}
			}
			for ( $i=0 ; $i<count($columns) ; $i++ ) {
				if ( isset($_POST['columns'][$i]['searchable']) && $_POST['columns'][$i]['searchable'] == "true" && $_POST['columns'][$i]['search']['value'] != '' ) {
					$data_types .= 's';
					$bind_params[]= '%'.$_POST['columns'][$i]['search']['value'].'%';
				}
			}
			
			if(strlen($data_types)>0){
				/* with call_user_func_array, array params must be passed by reference */
				$a_params[] = & $data_types;
			}
			
			for($i = 0; $i < count($bind_params); $i++) {
				$a_params[] = & $bind_params[$i];
			}
			
			if(strlen($data_types)>0){
				$this->bindParam($preparedStatement, $a_params); //possible data types i - integer, d - double, s - string, b - blob 
			}
			
			$rResult = $this->fetchResult($preparedStatement);
		
			$iFilteredTotal = current($this->getFilteredTotal());
			
			// Get total number of rows in query
			$sQuery = "SELECT COUNT(".$index_column.") cnt FROM ".$table;
			$iTotal = $this->countCustom($sQuery);
			
			// Output
			$output = array(
				"draw" => intval($_POST['draw']),
				"recordsTotal" => $iTotal,
				"recordsFiltered" => $iFilteredTotal,
				//"query" => $preparedStatement,		add for debugging
				"data" => array()
			);
			
			// Return array of values
			foreach($rResult as $aRow) {
				/* $row = array();			
				for ( $i = 0; $i < count($columns); $i++ ) {
					if ( $columns[$i] == "version" ) {
						// Special output formatting for 'version' column
						$row[] = ($aRow[ $columns[$i] ]=="0") ? '-' : $aRow[ $columns[$i] ];
					}
					else if ( $columns[$i] != ' ' ) {
						$row[] = $aRow[ preg_replace("/`[A-Za-z]+`\.|`/", "", $columns[$i]) ];
					}
				} 
				$output['data'][] = $row;*/
				$output['data'][] = $aRow;
			}
			
			echo json_encode( $output );
		}
	}
}
?>