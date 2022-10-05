import React from "react";
import {Modal, ModalHeader, ModalBody} from "reactstrap";
import { Link } from "react-router-dom";
import {Button, Form, FormGroup, Input, Col, Row, Label} from 'reactstrap';
import Select from 'react-select';
import { locOptions } from './locations.js';
// import $, { post } from "jquery";  // TODO: what does it do?

class Home extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            search: '',
            location: 'NA',
            sort: 'NA',
            posts: [],
            // posts:[
            //     {postID:'1', title:'title', location:'loc', startTime:'starttime',endTime:'endTime', credit:2.0, taskDetails:'Details',comments:[{commentor:'abc',commentee:'efg',postID:'1',content:'Comment'}]},
            //     {postID:'2', title:'titl2', location:'lo2', startTime:'starttime',endTime:'endTime', credit:2.0, taskDetails:'Details',comments:[{commentor:'abc2',commentee:'efg2',postID:'2',content:'Comment'},{commentor:'abc22',commentee:'efg22',postID:'2',content:'Comment'}]}
            //     ],
            isCommentOpen: false,
            selectedPost: '',
            selectedComments: []
        }
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleInputChange = this.handleInputChange.bind(this);
        this.handleSelectChange = this.handleSelectChange.bind(this);
        this.handleSortChange = this.handleSortChange.bind(this);
        this.handleChangeSelected = this.handleChangeSelected.bind(this);
        this.toggleComment = this.toggleComment.bind(this);
    }

    componentDidMount(){
        if(localStorage.getItem('token')!=null){
            if(localStorage.getItem('search') != null) this.setState({search: localStorage.getItem('search')});
            if(localStorage.getItem('location') != null) this.setState({location: localStorage.getItem('location')});
            if(localStorage.getItem('sort') != null) this.setState({sort: localStorage.getItem('sort')});
            const url = "/api/v1/posts/index";
            const keyword = this.state.search === '' ? 'NA' : this.state.search;
            const loc = this.state.location == null || this.state.location.label === undefined ? 'NA' : this.state.location.label;
            const sortBy = this.state.sort == null || this.state.sort.value === undefined ? 'NA' : this.state.sort.value;
            const params = "/"+keyword+"/"+loc+"/"+sortBy;
            fetch(url+params)
                .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("Network response was not ok.");
                })
                .then(response => {
                    this.setState({ posts: response })
                }
                    )
                .catch(() => this.props.history.push("/"));
        }
        else{
            alert("Please login or sign up first!");
        }
    }

    handleInputChange(event){
        const target = event.target;
        const value = target.value;
        const name = target.name;

        this.setState({
            [name]: value
        });
    }

    handleSelectChange = (location) => {
        this.setState({ location });
    };

    handleSortChange = (sort) => {
        this.setState({ sort });
    };

    handleSubmit(event){
        event.preventDefault();
        if(localStorage.getItem('token')!=null){
            const url = "/api/v1/posts/index";
            const keyword = this.state.search === ''?'NA':this.state.search;
            const loc = this.state.location == null || this.state.location.label === undefined? 'NA' : this.state.location.label;
            const sortBy = this.state.sort == null || this.state.sort.value === undefined ? 'NA' : this.state.sort.value;
            const params = "/"+keyword+"/"+loc+"/"+sortBy;
            if(this.state.search!=='') localStorage.setItem("search", this.state.search);
            else
                localStorage.removeItem("search");
            if(this.state.location != null && this.state.location.label !== undefined) localStorage.setItem("location", this.state.location);
            else
                localStorage.removeItem("location");
            if(this.state.sort != null && this.state.sort.value !== undefined) localStorage.setItem("sort", this.state.sort);
            else
                localStorage.removeItem("sort");
            fetch(url+params)
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error("Network response was not ok.");
                })
                .then(response => {
                        this.setState({ posts: response })
                    }
                )
                .catch(() => this.props.history.push("/"));
        }
        else{
            alert("Please login or sign up first!");
        }
    }

    handleChangeSelected(postID){
        this.setState({current_post_id: postID});
        this.setState({selectedPost: postID}, function () {
            this.toggleComment()
        });
    }

    toggleComment(){
        var selected_post = this.state.posts.filter((post) => post.id == this.state.selectedPost)[0];
        this.setState({
            selectedComments: selected_post.comments,
            isCommentOpen: !this.state.isCommentOpen
        });
    }

    render(){

        const sortOptions = [
            { value: 'NA', label: 'Our Choice' },
            { value: 'postdate', label: 'Post Date' },
            { value: 'credit', label: 'Credit' }
        ]

        const post = this.state.posts.map((post) => {
            return (
                <div key={post.id} className="col-12 col-md-8 offset-md-1" style={{marginBottom:"30px", borderStyle:"outset", borderRadius:"10px", borderWidth:"1px", borderColor:"rgba(224,224,224,0.3)"}}>
                    <div className="col-12 col-md-6 offset-md-3" style={{marginTop:"40px"}}>
                        <p><strong>Title:</strong> {post.title}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Location:</strong> {post.location}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Room:</strong> {post.room}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Start Time:</strong> {post.startTime}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>End Time:</strong> {post.endTime}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Credit:</strong> {post.credit}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Request:</strong> {post.taskDetails}</p>
                    </div>
                    <div className="row">
                        <div className="col-6 col-md-2 offset-md-5" style={{fontSize:"10px",height:"40px",paddingTop:"16px", paddingRight:"0px",marginRight:"0px",marginBottom:"20px"}}>
                            <center><strong><Link   onClick={() => this.handleChangeSelected(post.id)}>
                                                <i class="fa fa-chevron-circle-down" aria-hidden="true" style={{color: "rgba(0, 51, 160, 1)"}}/> Show Comment(s)
                                            </Link></strong></center>
                        </div>
                        <div className="col-6 col-md-4 border" style={{borderRadius:"5px", backgroundColor:"rgba(0, 51, 160, 1)", height:"40px",paddingTop:"8px", paddingLeft:"0px",marginLeft:"0px",marginBottom:"20px"}}>
                            <center><strong><Link   to={{pathname: `/spost/${post.id}`}}style={{ color: '#FFF' }}>
                                                        <i class="fa fa-hand-paper-o" aria-hidden="true"/> Want to Help
                                            </Link></strong></center>
                        </div>
                    </div>
                </div>
            );
        });

        var comment = this.state.selectedComments.map((comment) => {
            return(
                <div style={{marginBottom:"30px", borderStyle:"outset", borderRadius:"10px", borderWidth:"1px", borderColor:"rgba(224,224,224,0.3)"}}>
                    <div className="col-12 col-md-6 offset-md-3" style={{marginTop:"20px"}}>
                        <p><strong>Commenter:</strong> {comment.commenter}</p>
                    </div>
                    {/*<div className="col-12 col-md-6 offset-md-3">*/}
                    {/*    <p><strong>Commentee:</strong> {comment.commentee}</p>*/}
                    {/*</div>*/}
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Content:</strong> {comment.content}</p>
                    </div>
                </div>
            );
        });

        return(
            <>
                <div className="container">
                    <div className="col-12" style={{marginTop:"100px"}}>
                        <div className="row">
                            <div className="col-12 col-md-6">
                            <h5 style={{fontFamily:"Arial Black", display:"inline"}}>All requests</h5>
                            </div>
                            <div className="col-12 col-md-4 offset-col-md-2 ms-auto border" style={{borderRadius:"5px", backgroundColor:"rgba(108, 172, 228, 0.8)",height:"40px", paddingTop:"8px"}}>
                                <center><strong>
                                    <Link to={'/post'} style={{ color: '#FFF' }}><i class="fa fa-plus" aria-hidden="true"/> Post a new request</Link>
                                </strong></center>
                            </div>
                        </div>
                        <div className="col-12">
                            <Form onSubmit={this.handleSubmit}>
                                <Row>
                                    <Col sm={9} md={10} className="mr-auto">
                                        <i className="fa fa-search fa-lg icon"/>
                                        <FormGroup>
                                            <Input  type="text" className="search-bar" name="search" value={this.state.search} placeholder="Search.." onChange={this.handleInputChange}
                                                    style={{paddingLeft:"40px"}}/>
                                        </FormGroup>
                                    </Col>
                                    <Col sm={3} md={2}>
                                        <FormGroup>
                                            <Button type="submit" className="searchButton" style={{backgroundColor:"white", border:"none"}}>
                                                <b style={{color:"rgb(2, 33, 105)"}}><center>Search</center></b>
                                            </Button>
                                        </FormGroup>
                                    </Col>
                                </Row>
                                <Row>
                                    <Col sm={3} md={2}>
                                        <p  style={{paddingTop:"8px"}}>Location</p>
                                    </Col>
                                    <Col sm={9} md={4}>
                                        <FormGroup>
                                            <Select
                                                id="location"
                                                name="location"
                                                value={this.state.location}
                                                onChange={this.handleSelectChange}
                                                options={locOptions}
                                                isSearchable={true}
                                                isClearable={true}
                                            />
                                        </FormGroup>
                                    </Col>
                                    <Col xs={12} sm={3} md={{size: 2, offset: 1}}>
                                        <p style={{paddingTop:"8px"}}>Sorted by</p>
                                    </Col>
                                    <Col xs={12} sm={9} md={3}>
                                        <FormGroup>
                                            <Select
                                                id="sort"
                                                name="sort"
                                                value={this.state.sort}
                                                onChange={this.handleSortChange}
                                                options={sortOptions}
                                                isSearchable={true}
                                                isClearable={true}
                                            />
                                        </FormGroup>
                                    </Col>
                                </Row>
                            </Form>
                        </div>
                        <hr className="separation" />
                    </div>
                    <div className="col-12" style={{marginTop:"50px"}}>
                        <div className="row">
                            {post}
                        </div>
                    </div>
                </div>
                <Modal isOpen={this.state.isCommentOpen} toggle={this.toggleComment}>
                    <ModalHeader toggle={this.toggleComment}>Comment(s)</ModalHeader>
                    <ModalBody style={{marginTop:"20px"}}>{comment}</ModalBody>
                </Modal>
            </>
        );
    }
}

export default Home;