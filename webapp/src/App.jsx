import './App.css'
import '@mantine/core/styles.css';
import {Grid, Skeleton, Container} from '@mantine/core';


function App() {
    const child = <Skeleton height={140} radius="md" animate={false}/>;

    return (
        <Container my="md">
            <Grid>
                <Grid.Col span={{base: 12, xs: 4}}>{child}</Grid.Col>
                <Grid.Col span={{base: 12, xs: 8}}>{child}</Grid.Col>
                <Grid.Col span={{base: 12, xs: 8}}>{child}</Grid.Col>
                <Grid.Col span={{base: 12, xs: 4}}>{child}</Grid.Col>
                <Grid.Col span={{base: 12, xs: 3}}>{child}</Grid.Col>
                <Grid.Col span={{base: 12, xs: 3}}>{child}</Grid.Col>
                <Grid.Col span={{base: 12, xs: 6}}>{child}</Grid.Col>
            </Grid>
        </Container>
    )
}

export default App
