import React from "react";
import { Progress } from "reactstrap";

export default function Loading() {
    return (
        <Progress
            animated
            value="100"
        />
    );
}
