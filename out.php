<?php

require_once('./modules/functions.php');

$univ_id = @$_GET['univ_id'];
$user_id = @$_GET['user_id'];
$year    = @$_GET['y'];
$month   = @$_GET['m'];
$room    = @$_GET['room_id'];
$teacher = @$_GET['teacher_id'];

$room_codes_r = array(
    '8011107B0' => 'cps_f11',
    '801140600' => 'cps_f14',
    '804051600' => 'crl',
    '801111100' => 'isl',
);

$lab = @$room_codes_r[$room] ?: $room;

$is_cache = @$_GET['is_cache'];
if (!$univ_id || !$year || !$room || !$teacher || !isset($month)) {
    header("location: ./?e");
    exit();
}

if ($is_cache) {
    setcookie("univ_id"    , $univ_id);
    setcookie("user_id"    , $user_id);
    setcookie("room_id"    , $room);
    setcookie("teacher_id" , $teacher);
}

if ($month != 0) {
    $days = $_GET['day'];
    $csv = generate_csv($univ_id, $user_id, $year, $month, $room, substr($room, 0, 3), $teacher, $days);
    $filename = "demand_{$year}_{$month}_{$user_id}_{$lab}.CSV";
    header('Cache-Control: public');
    header('Pragma: public');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="'. $filename); 
    echo $csv;
} else {
    $tmp_dir = './tmp/';
    $dir_name = "demand_{$univ_id}_{$year}_{$lab}";
    // ./tmp/hoge_2014
    $tmp_zip_dir = $tmp_dir . $dir_name . "/";
    @mkdir($tmp_zip_dir);
    // zip module
    $zip = new ZipArchive();
    $zipname = $dir_name . '.zip';
    $zip_path = $tmp_zip_dir . $zipname;
    $filenames = array();
    if (!file_exists($zip_path)) {
        if ($zip->open($zip_path, ZipArchive::CREATE) !==TRUE) {
            die('cannot open zipobj');
        }
        $filenames = array();
        $start = 1;
        if ($year == date('Y')) {
            $start = date('m');
        }
        foreach (range($start, 12) as $m) {
            $csv = generate_csv($univ_id, $user_id, $year, $m, $room, substr($room, 0, 3), $teacher);
            $filename = "{$dir_name}/demand_{$year}_{$m}_{$user_id}_{$lab}.CSV";
            $tmpfilename = $tmp_zip_dir . $m . '.CSV';
            $filenames[] = $tmpfilename;
            file_put_contents($tmpfilename, $csv);
            $zip->addFile($tmpfilename, $filename);
        }
        $zip->close();
    }
    header('Pragma: public');
    header("Content-Type: application/octet-stream");
    header("Content-Disposition: attachment; filename=" . $zipname);
    readfile($zip_path);
}
//@rmdir($tmp_zip_dir);
