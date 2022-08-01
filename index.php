<!DOCTYPE html>
<html>
<head>
<title>appcode title</title>
</head>
<body>

    <?php
    require_once __DIR__ . '/vendor/autoload.php';

    use Silarhi\Hello;

    $hello = new Hello();
    echo $hello->display() . "\n";
    ?>

</body>
</html>
